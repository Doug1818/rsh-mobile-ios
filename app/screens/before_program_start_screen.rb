module Screen
  class BeforeProgramStartScreen < PM::Screen

    attr_accessor :date

    stylesheet :before_program_start_styles

    TAGS = {  program_begins_label: 2, start_date_label: 3 }

    def on_load
      @views = NSBundle.mainBundle.loadNibNamed "before_program_start_view", owner:self, options:nil
      self.title = ''
      @date = self.date
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        @program_begins_label = view.viewWithTag TAGS[:program_begins_label]
        @start_date_label = view.viewWithTag TAGS[:start_date_label]

        layout(view, :main_view) do |main_view|

          unless @date.nil?
            parts = @date.split("-")

            year = parts[0]
            month = parts[1]
            day = parts[2]

            date = NSDate.from_components(year: year, month: month, day: day)

            @program_begins_label.alpha = 1

            @start_date_label.text = date.string_with_style(NSDateFormatterShortStyle)
            @start_date_label.alpha = 1
          else
          end
        end
      end
    end
  end
end
