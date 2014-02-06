module Screen
  class CheckInDetailsScreen < PM::TableScreen
    # stylesheet :check_in_details_styles
    # TAGS = { title: 0, instructions_label: 1, authentication_token_field: 2 }

    attr_accessor :date, :week, :is_update
    # include Teacup::TableViewDelegate

    title "Steps"

    def on_load
      @date = self.date || NSDate.today
      @week = self.week || nil
      @small_steps = @week['small_steps'] || nil
      @is_update = self.is_update || false
    end

    def open_step(args)
      open StepScreen.new(nav_bar: true, step: args[:step])
    end

    def table_data
      [{
        cells: @small_steps.map do |step|
          if !step[:note].to_s == '' || step[:attachments].any?
            {
              title: step[:name].capitalize,
              accessory_type: UITableViewCellAccessoryDisclosureIndicator,
              action: :open_step,
              arguments: { step: step }
            }
          else
            {
              title: step[:name].capitalize
            }
          end
        end
      }]
    end
  end
end
