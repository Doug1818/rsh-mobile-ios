# module Screen
  class CheckInDetailsScreen < PM::TableScreen
    # stylesheet :check_in_details_styles
    # TAGS = { title: 0, instructions_label: 1, authentication_token_field: 2 }

    attr_accessor :date, :week, :is_update, :comments
    # include Teacup::TableViewDelegate

    title "Check-in Details"

    def on_load
      @date = self.date || NSDate.today
      @week = self.week || nil
      @small_steps = @week['small_steps'] || nil
      @is_update = self.is_update || false
    end

    def open_step(args)
      open StepScreen.new(nav_bar: false, step: args[:step])
    end

    def table_data
      [{
        cells: @small_steps.map do |step|
          {
            title: step[:name].capitalize,
            action: :open_step,
            arguments: { step: step }
          }
        end
      }]
    end
  end
# end
