class RootScreen < MMDrawerController
  # You can inherit a screen from any UIViewController if you include the ScreenModule
  # Just make sure to implement the Obj-C methods in cocoatouch/view_controller.rb.
  include PM::ScreenModule

  title 'Schedule'

  def self.new(args = {})
    alloc.init.tap do |root_screen|
      root_screen.on_create(args)
    end
  end

  def centerViewController=(centerViewController)
    super
    self.title = centerViewController.title
  end

  def on_create(args={})
    super

    self.leftDrawerViewController   = Screen::MenuScreen.new(nav_bar: false)
    self.rightDrawerViewController  = nil
    self.centerViewController = App::Persistence[:program_authentication_token] ? day_screen : login_screen

    leftDrawerButton = MMDrawerBarButtonItem.alloc.initWithTarget self, action:"show_menu:"
    navigationItem.setLeftBarButtonItem leftDrawerButton, animated:true
  end

  def will_appear
    self.title = centerViewController.title
  end

  def show_menu(sender)
    toggleDrawerSide MMDrawerSideLeft, animated:true, completion: nil
  end

  def month_screen
    @month_screen ||= Screen::MonthScreen.new
  end

  def week_screen
    @week_screen ||= Screen::WeekScreen.new
  end

  def day_screen
    @day_screen ||= Screen::DayScreen.new
  end

  def check_in_screen
    @check_in_screen ||= Screen::CheckInScreen.new
  end

  def profile_screen
    @profile_screen ||= Screen::ProfileScreen.new
  end

  def signout_screen
    @signout_screen ||= Screen::SignoutScreen.new
  end

  def login_screen
    @login_screen ||= Screen::LoginScreen.new
  end

  def thank_you_screen
    @thank_you_screen ||= Screen::ThankYouScreen.new
  end
end
