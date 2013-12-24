module Screen
  class MenuScreen < PM::TableScreen
    stylesheet :menu_styles

    def table_data
      member_menu = [{
        cells: [
          { title: "Profile",   action: :show_screen, arguments: { screen_name: :profile_screen   }},
          { title: "Program",   action: :show_screen, arguments: { screen_name: :week_screen   }},
          { title: "Sign Out",   action: :show_screen, arguments: { screen_name: :signout_screen   }},
        ]
      }]

      guest_menu = [{
        cells: [
          { title: "Login",   action: :show_screen, arguments: { screen_name: :login_screen   }},
        ]
      }]

      App::Persistence[:authentication_token] ? member_menu : guest_menu
    end

    def root_screen
      mm_drawerController
    end

    def will_appear
      # move down for nav menu
      table_view.top = TOP_BELOW_MM_NAV
      table_view.height = table_view.superview.height - TOP_BELOW_MM_NAV
    end

    def show_screen(args)
      screen = root_screen.send(args[:screen_name])
      root_screen.centerViewController = screen
      root_screen.toggleDrawerSide MMDrawerSideLeft, animated:true, completion: nil
    end

    TABLE_HEIGHT = 276
    def will_appear
      footer = UIView.alloc.initWithFrame [[0,table_view.height-TABLE_HEIGHT],[table_view.width, table_view.height-TABLE_HEIGHT]]

      # make blank rows at the bottom not appear
      table_view.tableFooterView = footer
      layout(UIView, :footer) do |footer|
        table_view.tableFooterView = footer
        @made_by = subview(UILabel, :made_by, text: "Made by Right Side Health")
        @made_by.when_tapped do
          App.open_url 'http://www.rightsidehealth.com'
        end
      end
      @made_by.top = footer.height - 30 - TOP_BELOW_MM_NAV
    end
  end
end
