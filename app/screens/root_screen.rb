class RootScreen < MMDrawerController
  # You can inherit a screen from any UIViewController if you include the ScreenModule
  # Just make sure to implement the Obj-C methods in cocoatouch/view_controller.rb.
  include ProMotion::ScreenModule

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

    self.leftDrawerViewController   = Screen::Menu.new(nav_bar: false)
    self.rightDrawerViewController  = nil
    self.centerViewController       = week_view_screen

    leftDrawerButton = MMDrawerBarButtonItem.alloc.initWithTarget self, action:"show_menu:"
    navigationItem.setLeftBarButtonItem leftDrawerButton, animated:true
  end

  def will_appear
    self.title = centerViewController.title
  end

  def show_menu(sender)
    toggleDrawerSide MMDrawerSideLeft, animated:true, completion: nil
  end

  def week_view_screen
    @week_view_screen ||= Screen::Week.new
  end

  def profile_screen
    @profile_screen ||= Screen::Profile.new
  end

  def todos_screen
    @todos_screen ||= Screen::Todos.new
  end

  def supporters_screen
    @supporters_screen ||= Screen::Supporters.new
  end

  def signout_screen
    @signout_screen ||= Screen::Signout.new
  end
end
