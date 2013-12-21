module ScreenScreen
  class Signout < UIViewController
    include ProMotion::ScreenModule

    def viewDidLoad
      App::Persistence.delete(:authentication_token)
      open_screen RootScreen.new(nav_bar: true)
    end
  end
end
