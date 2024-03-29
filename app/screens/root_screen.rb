class RootScreen < MMDrawerController
  include PM::ScreenModule

  title ''

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

    data = {
      authentication_token: App::Persistence[:program_authentication_token],
      date: NSDate.today
    }
    BW::HTTP.get("#{Globals::API_ENDPOINT}/programs", { payload: data }) do |response|
      if response.ok?
        json_data = BW::JSON.parse(response.body.to_str)[:data]

        @program = json_data[:program]

        # If they haven't checked in yet and there are steps today, take them to the check in screen
        # Otherwise take them to the week screen 

        if @program.empty? || @program.has_key?(:program_start_date)
          screen = if App::Persistence[:program_authentication_token]
            program_start_date = @program[:program_start_date] || nil
            Screen::BeforeProgramStartScreen.new(nav_bar: true, date: program_start_date)
          else
            login_screen
          end
          self.centerViewController = screen
        else
          if @program[:requires_one_or_more_check_ins]
            self.centerViewController = App::Persistence[:program_authentication_token] ? check_in_screen : login_screen
          else
            self.centerViewController = App::Persistence[:program_authentication_token] ? week_screen : login_screen
          end
        end
      elsif response.status_code.to_s =~ /40\d/
        self.centerViewController = App::Persistence[:program_authentication_token] ? week_screen : login_screen
      else
        self.centerViewController = App::Persistence[:program_authentication_token] ? week_screen : login_screen
      end
    end

    leftDrawerButton = MMDrawerBarButtonItem.alloc.initWithTarget self, action:"show_menu:"
    navigationItem.setLeftBarButtonItem leftDrawerButton, animated:true
  end

  def will_appear
    self.title = centerViewController.title
  end

  def show_menu(sender)
    toggleDrawerSide MMDrawerSideLeft, animated:true, completion: nil
  end

  def excuse_screen
    @excuse_screen ||= Screen::ExcuseScreen.new
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

  def step_screen
    @step_screen ||= Screen::StepScreen.new
  end

  def check_in_details_screen
    @check_in_details_screen ||= Screen::CheckInDetailsScreen.new
  end

  def complex_check_in_screen
    @complex_check_in_screen ||= Screen::ComplexCheckInScreen.new
  end

  def single_check_in_details_screen
    @single_check_in_details_screen ||= Screen::SingleCheckInDetailsScreen.new
  end

  def multiple_check_in_details_screen
    @multiple_check_in_details_screen ||= Screen::MultipleCheckInDetailsScreen.new
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

  def before_program_start_screen
    @before_program_start_screen ||= Screen::BeforeProgramStartScreen.new
  end

  def thank_you_screen
    @thank_you_screen ||= Screen::ThankYouScreen.new
  end

  def support_screen
    @support_screen ||= Screen::SupportScreen.new
  end
end
