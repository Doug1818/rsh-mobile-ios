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
      data = { authentication_token: textField.text }

      BW::HTTP.post("#{Globals::API_ENDPOINT}/sessions", { payload: data }) do |response|
        if response.ok?
          response = BW::JSON.parse(response.body.to_str)
          App::Persistence[:authentication_token] = response[:data][:program][:authentication_token]

          open RootScreen
        elsif response.status_code.to_s =~ /40\d/
          App.alert("We did not recognize that code. Please try again.")
        else
          App.alert(response.error_message)
        end
      end
    end
  end
end
