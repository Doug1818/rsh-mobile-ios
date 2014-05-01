module Screen
  class LoginScreen < PM::Screen
    stylesheet :login_styles
    TAGS = { title: 0, instructions_label: 1, authentication_token_field: 2, terms_label: 3, terms_text: 4, username_field: 5 }

    def on_load
      self.title = ''
      @views = NSBundle.mainBundle.loadNibNamed "login", owner:self, options:nil
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        mm_drawerController.title = title

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        @authentication_token_field = view.viewWithTag TAGS[:authentication_token_field]
        @authentication_token_field.delegate = self

        @username_field = view.viewWithTag TAGS[:username_field]
        @username_field.keyboardType = UIKeyboardTypeEmailAddress
        @username_field.delegate = self

        @terms_text = view.viewWithTag TAGS[:terms_text]
        @terms_text.backgroundColor = "#f1f2f2".to_color
        @terms_text.layer.cornerRadius = 11
        # @terms_text.layer.borderWidth = 1.0
        # @terms_text.layer.borderColor = UIColor.grayColor
        @terms_text.delegate = self
      end
    end

    # form submission
    def textFieldShouldReturn(textField)
      NSLog("here in signin")
    

      Program.authenticate_program(textField.text) do |success, program|
        NSLog("DONE WITH AUTHENTICATE PROGRAM")
        if success
          
          program.persist_data
          program.user.persist_data
          
          data = { user: { last_sign_in_at: NSDate.date }}
          User.update_profile(data) do |success, user|
            if success
              NSLog("Updated user's last_sign_in_at.")
            else
              NSLog("Error updating user's last_sign_in_at.")
            end
          end

          # In case they're not subscribed yet...
          PFPush.subscribeToChannelInBackground("all_users")
          PFPush.subscribeToChannelInBackground("user_#{App::Persistence[:user_id]}") if App::Persistence[:user_id]

          open RootScreen
        else
          App.alert("Password is incorrect. Please try again.")
        end
      end
    end
  end
end
