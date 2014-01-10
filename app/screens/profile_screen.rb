module Screen
 class ProfileScreen < PM::Screen

    stylesheet :profile_styles
    TAGS = { profile_name: 2, profile_email: 3, profile_image: 4, profile_phone: 5, profile_timezone: 6 }

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

      profile_email = view.viewWithTag TAGS[:profile_email]
      profile_name = view.viewWithTag TAGS[:profile_name]
      profile_phone = view.viewWithTag TAGS[:profile_phone]
      @profile_image = view.viewWithTag TAGS[:profile_image]


      User.get_profile do |success, user|
        if success
          profile_email.text = user.email
          profile_name.text = "#{ user.first_name } #{ user.last_name }"
          profile_phone.text = user.phone
          unless user.avatar.nil?
            image_url = user.avatar
            image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(image_url))
            @profile_image.setBackgroundImage(UIImage.imageWithData(image_data), forState: UIControlStateNormal)
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
        image = UIImageJPEGRepresentation(image_view.image, 9);

        if image   
          encodedData = [image].pack("m0")

          data = {
            authentication_token: App::Persistence[:program_authentication_token],
            avatar: encodedData
          }
          BW::HTTP.put("#{Globals::API_ENDPOINT}/users/#{App::Persistence[:user_id]}", {payload: data}) do |response|
            if response.ok?
              json_data = BW::JSON.parse(response.body.to_str)[:data]
              user = json_data[:user]
              image_url = user[:avatar][:large][:url]
              image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(image_url))
              @profile_image.setBackgroundImage(UIImage.imageWithData(image_data), forState: UIControlStateNormal)
            end
          end
        end
      end
    end
  end
end
