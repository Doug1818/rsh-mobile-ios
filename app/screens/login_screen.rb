module Screen
  class LoginScreen < PM::Screen
    title ''

    TAGS = { title: 0, instructions_label: 1, authentication_token: 2 }

    def loadView
      views = NSBundle.mainBundle.loadNibNamed "login", owner:self, options:nil
      self.view = views[0]
    end

    def viewDidLoad
      @authentication_token = view.viewWithTag TAGS[:authentication_token]
      @authentication_token.delegate = self
    end

    def textFieldShouldReturn(textField)

      Program.authenticate_program(textField.text) do |success, program|
        if success
          @program = program

          App::Persistence[:program_authentication_token] = @program.authentication_token
          App::Persistence[:user_email] = @program.user.email
          App::Persistence[:user_id] = @program.user.id

          open RootScreen
        else
          App.alert("We did not recognize that code. Please try again.")
        end
      end
    end
  end
end
