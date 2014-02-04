# module Screen
  class CheckInDetailsScreen < PM::TableScreen
    # stylesheet :check_in_details_styles
    # TAGS = { title: 0, instructions_label: 1, authentication_token_field: 2 }

    attr_accessor :date, :week, :is_update, :comments
    # include Teacup::TableViewDelegate

    title "Check-in Details"

    def open_step(args)
      open StepScreen.new(nav_bar: false, step_id: args[:step_id])
    end

    def table_data
      [{
        cells: (0..200).map do |n|
          {
            title: "Step #{n}",
            action: :open_step,
            arguments: { step_id: n }
          }
        end
      }]
    end
  end
# end
