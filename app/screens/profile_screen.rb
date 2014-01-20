module Screen
 class ProfileScreen < PM::Screen

    TAGS = { container_view: 1, profile_name: 2, profile_email: 3, profile_image: 4, profile_phone_field: 5, profile_timezone_field: 6 }

    def on_load
      self.title = ''
      @views = NSBundle.mainBundle.loadNibNamed "profile", owner:self, options:nil
    end

    def will_appear

      @scroll = UIScrollView.alloc.initWithFrame(@views[0].bounds)
      @scroll.contentSize = CGSizeMake(@scroll.frame.size.width, content_height(@scroll) + 600)
      @scroll.backgroundColor = UIColor.whiteColor
      self.view  = @scroll

      add_to self.view, @views[0]

      @container = view.viewWithTag TAGS[:container_view]

      @profile_email          = view.viewWithTag TAGS[:profile_email]
      @profile_name           = view.viewWithTag TAGS[:profile_name]
      @profile_phone_field    = view.viewWithTag TAGS[:profile_phone_field]
      @profile_timezone_field = view.viewWithTag TAGS[:profile_timezone_field]

      @profile_image = view.viewWithTag TAGS[:profile_image]

      @profile_phone_field.delegate = self
      @profile_timezone_field.delegate = self

      User.get_profile do |success, user|
        if success
          user.persist_data

          @profile_email.text           = App::Persistence[:user_email]
          @profile_name.text            = App::Persistence[:user_full_name]
          @profile_phone_field.text     = App::Persistence[:user_phone]
          @profile_timezone_field.text  = App::Persistence[:user_timezone]

          unless user.avatar.nil?
            image_url = user.avatar

            unless image_url == '/assets/default-avatar.png'
              image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(image_url))
              @profile_image.setBackgroundImage(UIImage.imageWithData(image_data), forState: UIControlStateNormal)
            end
          end
        else
          App.alert("oops")
        end
      end

      @profile_image.addTarget self, action: 'chooseProfileImage:', forControlEvents:UIControlEventTouchUpInside
    end

    def chooseProfileImage(sender)
      BW::Device.camera.any.picture(media_types: [:image]) do |result|
        image_view = UIImageView.alloc.initWithImage(result[:original_image])
        image = UIImageJPEGRepresentation(image_view.image, 0.0);

        if image
          encodedData = [image].pack("m0")

          data = { user: { image_data: encodedData }}

          User.update_profile(data) do |success, user|
            if success
              image_url = user[:avatar][:large][:url]
              image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(image_url))
              @profile_image.setBackgroundImage(UIImage.imageWithData(image_data), forState: UIControlStateNormal)
            else
              NSLog("Error updating profile.")
            end
          end
        end
      end
    end

    # form submission
    def textFieldShouldReturn(textField)

      data = {}

      data[:user] = case textField
      when @profile_phone_field
        { phone: textField.text }
      when @profile_timezone_field
        { timezone: textField.text }
      else
      end

      User.update_profile(data) do |success, user|
        if success
          NSLog("User profile updated.")
        else
          NSLog("Error updating user profile.")
        end
      end

      container_frame = @container.frame
      container_frame.origin.y += 200

      UIView.animateWithDuration(0.3,
        animations: lambda {
          @container.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = false
        }
      )

      # this will hide the keyboard
      textField.resignFirstResponder
    end

    def textFieldDidBeginEditing(textField)
      # if we've already shifted the view up, don't do it again
      return if @offset

      # grab our current frame and modify it so it's visible
      container_frame = @container.frame
      container_frame.origin.y -= 200

      # animate the replacement of the current frame with the new one
      UIView.animateWithDuration(0.3,
        animations: lambda {
          @container.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = true
        }
      )
    end
  end
end
