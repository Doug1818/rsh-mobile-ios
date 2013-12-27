module Screen
  class DayScreen < PM::Screen

    stylesheet :day_styles
    TAGS = { day_label: 2 }

    def on_load
      self.title = 'Day'
      @views = NSBundle.mainBundle.loadNibNamed "day_view", owner:self, options:nil
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        mm_drawerController.title = title

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        @day_label = view.viewWithTag TAGS[:day_label]
        @date = App::Persistence[:selected_date] || NSDate.today
        date_string_for_label = @date.string_with_format('MMM d')
        @day_label.text = date_string_for_label
      end
    end
  end
end
