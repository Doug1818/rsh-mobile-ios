module Screen
  class SingleCheckInDetailsScreen < PM::Screen

    attr_accessor :date, :small_step, :is_update

    TAGS = { container_view: 1, small_step_name_label: 2, small_step_frequency_label: 3, notes_scroll_view: 4, notes_label: 5, comments_text_view: 6, done_button: 7 }

    def on_load
      @date = self.date || NSDate.today
      @small_step = self.small_step || nil
      @is_update = self.is_update || false

      @comments = ''

      self.title = @date.string_with_format('MMM d')
      @views = NSBundle.mainBundle.loadNibNamed "single_check_in_details_view", owner:self, options:nil
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        mm_drawerController.title = title

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        @container = view.viewWithTag TAGS[:container_view]

        @small_step_name_label = view.viewWithTag TAGS[:small_step_name_label]
        @small_step_name_label.sizeToFit
        @small_step_name_label.text = "#{ @small_step[:name].capitalize }"

        @small_step_frequency_label = view.viewWithTag TAGS[:small_step_frequency_label]
        @small_step_frequency_label.sizeToFit

        @small_step_frequency_label.text = case @small_step[:frequency_name]
        when 'Daily'
          "Daily"
        when 'Times Per Week' 
          if @small_step[:times_per_week] == 1
            "#{ @small_step[:times_per_week] } time per week"
          else
            "#{ @small_step[:times_per_week] } times per week"
          end
        when 'Specific Days'
          @small_step[:specific_days]
        else
          ''
        end

        @notes_scroll_view = view.viewWithTag TAGS[:notes_scroll_view]

        @notes_label = view.viewWithTag TAGS[:notes_label]

        @comments_text_view = view.viewWithTag TAGS[:comments_text_view]
        @comments_text_view.layer.borderWidth = 2.0
        @comments_text_view.layer.borderColor = UIColor.grayColor
        @comments_text_view.delegate = self

        @done_btn = view.viewWithTag TAGS[:done_button]

        @done_btn.when_tapped do
          screen = CheckInScreen.new(nav_bar: true, date: @date, is_update: @is_update, comments: @comments)
          mm_drawerController.centerViewController = screen
          mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
        end
      end
    end

    def textView(textView, shouldChangeTextInRange: range, replacementText: text)

      if text == "\n"
        textView.resignFirstResponder
        false
      else
        true
      end
    end

    def textViewDidBeginEditing(textView)
      # if we've already shifted the view up, don't do it again
      return if @offset

      # grab our current frame and modify it so it's visible
      container_frame = @container.frame
      container_frame.origin.y -= 200

      # animate the replacement of the current frame with the new one
      UIView.animateWithDuration(0.3,
        animations: lambda {
          @container.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = true
        }
      )
      @done_btn.enabled = false
    end

    def textViewDidEndEditing(textView)
      @comments = textView.text

      container_frame = @container.frame
      container_frame.origin.y += 200

      UIView.animateWithDuration(0.3,
        animations: lambda {
          @container.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = false
        }
      )

      @done_btn.enabled = true

    end

  end
end
