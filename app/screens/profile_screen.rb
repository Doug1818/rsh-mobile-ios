module Screen
 class ProfileScreen < PM::Screen

    stylesheet :profile_styles
    TAGS = { profile_name: 2, profile_email: 3, profile_image: 4 }

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

      data = {authentication_token: App::Persistence[:program_authentication_token]}
      BW::HTTP.get("#{Globals::API_ENDPOINT}/users", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]
          profile_email.text = json_data[:user][:email]
          profile_name.text = "#{ json_data[:user][:first_name] } #{ json_data[:user][:last_name] }"
        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end

      profile_image = view.viewWithTag TAGS[:profile_image]
      profile_image.addTarget self, action: 'chooseProfileImage:', forControlEvents:UIControlEventTouchUpInside
    end

    def chooseProfileImage(sender)
      BW::Device.camera.any.picture(media_types: [:image]) do |result|
        image_view = UIImageView.alloc.initWithImage(result[:original_image])
        image = UIImageJPEGRepresentation(image_view.image, 9);
        encodedData = [image].pack("m0")

        data = {
          authentication_token: App::Persistence[:program_authentication_token],
          avatar: encodedData
        }
        BW::HTTP.put("#{Globals::API_ENDPOINT}/users/#{App::Persistence[:user_id]}", {payload: data}) do |response|
          if response.ok?
            App.alert("OK!")
          end
        end
      end
    end
  end
end
