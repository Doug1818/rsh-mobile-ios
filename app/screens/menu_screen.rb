module Screen
  class MenuScreen < PM::TableScreen
    include Teacup::TableViewDelegate
    stylesheet :menu_styles

    def table_data
      member_menu = [{
        cells: [
          { title: "Profile", backgroundColor: "#6d6e71".to_color, textColor: UIColor.whiteColor, action: :show_screen, arguments: { screen_name: :profile_screen   }},
          { title: "Program", backgroundColor: "#6d6e71".to_color, textColor: UIColor.whiteColor, action: :show_screen, arguments: { screen_name: :week_screen   }},
          { title: "Sign Out", backgroundColor: "#6d6e71".to_color, textColor: UIColor.whiteColor, action: :show_screen, arguments: { screen_name: :signout_screen   }},
        ]
      }]

      guest_menu = [{
        cells: [
          { title: "Login",   action: :show_screen, arguments: { screen_name: :login_screen   }},
        ]
      }]

      App::Persistence[:program_authentication_token] ? member_menu : guest_menu
    end

    def root_screen
      mm_drawerController
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        layout(table_view, :main_view) do
          table_view.tableFooterView = UIView.alloc.initWithFrame(CGRectZero)
        end
      end
    end

    def show_screen(args)
      screen = root_screen.send(args[:screen_name])
      root_screen.centerViewController = screen
      root_screen.toggleDrawerSide MMDrawerSideLeft, animated:true, completion: nil
    end
  end
end
