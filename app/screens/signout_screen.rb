module Screen
  class SignoutScreen < UIViewController
    include ProMotion::ScreenModule

    def viewDidLoad
      App::Persistence.delete(:program_authentication_token)
      open_screen RootScreen.new(nav_bar: true)
    end
  end
end
