module Screen
  class SingleCheckInDetailsScreen < PM::Screen

    attr_accessor :date, :small_step, :is_update, :comments

    TAGS = { container_view: 1, small_step_name_label: 2, small_step_frequency_label: 3, 
              notes_text_view: 4, comments_text_view: 5, done_button: 6, attachment_scroll_view: 7 }

    def on_load
      @date = self.date || NSDate.today
      @small_step = self.small_step || nil
      @is_update = self.is_update || false
      @comments = self.comments || ''

      @views = NSBundle.mainBundle.loadNibNamed "single_check_in_details_view", owner:self, options:nil
    end

    def will_appear

      super

      @scroll = UIScrollView.alloc.initWithFrame(@views[0].bounds)
      @scroll.contentSize = CGSizeMake(1, content_height(@scroll) + 600)
      @scroll.backgroundColor = UIColor.whiteColor
      self.view  = @scroll

      add_to self.view, @views[0]

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

      @notes_text_view = view.viewWithTag TAGS[:notes_text_view]

      @notes_text_view.text = @small_step[:note] || "No notes yet."
      @notes_text_view.font = UIFont.fontWithName("Helvetica Neue", size: 15.0)
      @notes_text_view.textColor = '#68696C'.to_color

      @attachment_scroll_view = view.viewWithTag TAGS[:attachment_scroll_view]
      @attachment_scroll_view.contentSize = CGSizeMake(@attachment_scroll_view.frame.size.width, content_height(@attachment_scroll_view) + 50)

      if @small_step[:attachments].count == 0
        @no_attachments_label = UILabel.alloc.init
        @no_attachments_label.frame = CGRectMake(0, 0, 200, 25)
        @no_attachments_label.textAlignment = UITextAlignmentLeft
        @no_attachments_label.font = UIFont.fontWithName("Helvetica Neue", size: 15.0)
        @no_attachments_label.textColor = '#68696C'.to_color
        @no_attachments_label.text = "No attachments yet."

        add_to @attachment_scroll_view, @no_attachments_label
      else
        @small_step[:attachments].each_with_index do |attachment, index|
          instance_variable_set("@attachment_label_#{ index }", "attachment_#{ index }")

          @attachment_var = instance_variable_get("@attachment_label_#{ index }")

          @attachment_var = UIButton.alloc.init
          @attachment_var.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
          @attachment_var.titleLabel.font = UIFont.boldSystemFontOfSize(15)
          @attachment_var.setTitleColor(UIColor.orangeColor, forState: UIControlStateNormal)

          title = attachment[:friendly_name]

          @attachment_var.setTitle("#{ title }", forState: UIControlStateNormal)
          @attachment_var.frame = CGRectMake(0, (index * 20), 200, 25)

          @attachment_var.when_tapped do 
            url = attachment[:url]
            UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
          end

          add_to @attachment_scroll_view, @attachment_var
        end
      end

      @comments_text_view = view.viewWithTag TAGS[:comments_text_view]
      @comments_text_view.layer.borderWidth = 2.0
      @comments_text_view.layer.borderColor = UIColor.grayColor
      @comments_text_view.text = @comments
      @comments_text_view.delegate = self

      @done_btn = view.viewWithTag TAGS[:done_button]

      @done_btn.when_tapped do
        screen = CheckInScreen.new(nav_bar: true, date: @date, is_update: @is_update, comments: @comments)
        mm_drawerController.centerViewController = screen
        mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
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
