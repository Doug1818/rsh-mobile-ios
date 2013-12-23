module Screen
 class DayScreen < PM::Screen

    title ''

    TAGS = {day_label: 2}

    def loadView
      views = NSBundle.mainBundle.loadNibNamed "day_view", owner:self, options:nil
      self.view = views[0]
    end

    def viewDidLoad
      @day_label = view.viewWithTag TAGS[:day_label]
      @date = App::Persistence[:selected_date] || NSDate.today
      date_string_for_label = @date.string_with_format('MMM d')
      @day_label.text = date_string_for_label
    end
  end
end
