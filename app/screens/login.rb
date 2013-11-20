module Screen
  class Login < PM::FormotionScreen

    title 'Welcome!'

    def will_appear
      mm_drawerController.title = title
    end

    def viewWillAppear(animated)
      # move down for nav menu
      self.tableView.top = TOP_BELOW_MM_NAV
      self.tableView.height = self.tableView.superview.height - self.tableView.top

      view = UIView.alloc.initWithFrame(CGRect.new([0, 0], [300, 110]))
      label = UILabel.alloc.initWithFrame(CGRect.new([20, 0], [280, 110]))
      label.numberOfLines = 0
      label.lineBreakMode = UILineBreakModeWordWrap
      label.text = "To begin using Right Side Health, please enter the code you received from your coach."
      view.addSubview(label)

      self.tableView.tableHeaderView = view
    end

    def on_load
      self.form.on_submit do |form|
        data = self.form.render
        puts "INVITE CODE: #{data[:authentication_token]}"

        BW::HTTP.post("http://localhost:3000/api/v1/sessions", { payload: data }) do |response|

          if response.ok?
            response = BW::JSON.parse(response.body.to_str)

            # puts "JSON IS: #{response[:data][:program][:authentication_token]}"

            App::Persistence[:authentication_token] = response[:data][:program][:authentication_token]
            open RootScreen
          elsif response.status_code.to_s =~ /40\d/
            puts "RESPONSE: LOGIN FAILED"
            # App.alert("Login failed")
          else
            puts "GENERAL ERROR MESSAGE"
            # App.alert(response.error_message)
          end

        end

      end
    end

    def table_data
      {
        sections: [{
          rows: [{
            title: "Invitation Code",
            key: :authentication_token,
            type: :text,
            auto_correction: :no,
            auto_capitalization: :none
          }]
        }, {
          rows: [{
            title: "Log In!",
            type: :submit,
          }]

        }]
      }
    end
  end
end
