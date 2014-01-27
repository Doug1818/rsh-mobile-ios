module Screen
  class MultipleCheckInDetailsScreen < PM::Screen
    stylesheet :multiple_check_in_details_styles
    # TAGS = { title: 0, instructions_label: 1, authentication_token_field: 2 }

    attr_accessor :date, :week, :is_update, :comments
    include Teacup::TableViewDelegate

    @@cell_identifier = nil

    def on_load
      @date = self.date || NSDate.today
      @week = self.week || nil
      @small_steps = @week['small_steps'] || nil
      @is_update = self.is_update || false
      @comments = self.comments || ''

      @no_small_steps = []
      @yes_small_steps = []

      @no_button_image = UIImage.imageNamed('small-no-button')
      @yes_button_image = UIImage.imageNamed('small-yes-button')

      @no_button_pressed_image = UIImage.imageNamed('small-no-button-pressed')
      @yes_button_pressed_image = UIImage.imageNamed('small-yes-button-pressed')
    end

    def will_appear
      super

      view.subviews.each &:removeFromSuperview

      @scroll_view = subview UIScrollView, :scroll_view do 
        subview(UILabel, :homework_label)
        @table_view = subview homework_table, :table_view
        @table_view.height = @data.count * 40 # 40 is the height of each cell; make the table height equal to the height of all of the cells
        @notes_label = subview(UILabel, :notes_label)
        table_height = @table_view.frame.origin.y + @table_view.height
        @notes_label.top = table_height

        @notes_text = subview(UILabel, :notes_text)
        
        notes = []
        @data.each do |small_step|
          if small_step[:note] == '' or small_step[:note] == nil
            notes << "#{ small_step[:name].capitalize }\n\nNo notes yet.\n"
          else
            notes << "#{ small_step[:name].capitalize }\n\n#{ small_step[:note] }\n"
          end
        end

        @notes_text.text = notes.join("\n")

        @notes_text.lineBreakMode = NSLineBreakByWordWrapping;
        @notes_text.numberOfLines = 0;
        @notes_text.top = table_height + 60
        @notes_text.sizeToFit

        notes_height = @notes_text.frame.origin.y + @notes_text.height

        @attachments_label = subview(UILabel, :attachments_label)
        @attachments_label.top = notes_height + 110

        attachment_data = []

        @data.each_with_index do |small_step, small_step_index|
          attachments = small_step[:attachments]

          attachments.each do |attachment|
            attachment_data << attachment
          end
        end

        @last_attachment = nil
        attachment_data.each_with_index do |attachment, index|
          instance_variable_set("@attachment_label_#{ index }", "attachment_#{ index }")

          @attachment_var = instance_variable_get("@attachment_label_#{ index }")

          @attachment_var = subview(UIButton.alloc.init, :attachment_button)
          @attachment_var.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
          @attachment_var.titleLabel.font = UIFont.boldSystemFontOfSize(15)
          @attachment_var.setTitleColor(UIColor.orangeColor, forState: UIControlStateNormal)

          title = attachment[:friendly_name]

          @attachment_var.setTitle("#{ title }", forState: UIControlStateNormal)
          @attachment_var.frame = CGRectMake(0, index * 20, 200, 25)
          @attachment_var.top = notes_height + 180 + (30 * index)

          @attachment_var.when_tapped do 
            url = attachment[:url]
            UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
          end
          @last_attachment = @attachment_var
        end

        unless @last_attachment.nil?
          comment_top = @last_attachment.height + @last_attachment.frame.origin.y
        else
          comment_top = @attachments_label.height + @attachments_label.frame.origin.y + 60
        end

        @comments_label = subview(UILabel, :comments_label)
        @comments_label.top = comment_top

        @comments_view = subview(UITextView.alloc.initWithFrame(CGRectMake(20, comment_top + 80, 250, 100)), :comments_view)
        @comments_view.layer.borderWidth = 1.0
        @comments_view.delegate = self
      end

      subview(UIView, :multiple_check_in_details_nav) do
        @done_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :done_btn)
      end

      @done_btn.when_tapped do
        if @no_small_steps.count > 0 or @yes_small_steps.count > 0
          if @no_small_steps.count > 0
            createCheckIns(@no_small_steps, 0)
          end

          if @yes_small_steps.count > 0
            createCheckIns(@yes_small_steps, 1)
          end
          mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
          screen = mm_drawerController.send(:thank_you_screen)
          mm_drawerController.centerViewController = screen
        else
          mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
        end
      end

      # Temporary hack for drawer multiple_check_in_details_nav_back
      subview(UIView, :multiple_check_in_details_nav_back) do
        @nav_back_btn = subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :nav_back_btn)
      end
      @nav_back_btn.when_tapped do
          mm_drawerController.toggleDrawerSide MMDrawerSideRight, animated:true, completion: nil
        end
      # end hack
      @scroll_view.contentSize = CGSizeMake(@scroll_view.frame.size.width, content_height(@scroll_view) + 600)
      @scroll_view.backgroundColor = UIColor.whiteColor
    end

    def homework_table
      @data ||= []

      @table_view = subview(UITableView.alloc.initWithFrame(CGRectMake(10, 120, 320, 200)))
      @table_view.dataSource = self
      @table_view.delegate = self
      @table_view.separatorStyle = UITableViewCellSeparatorStyleNone

      @data = @small_steps

      return @table_view
    end

    def tableView(table_view, heightForRowAtIndexPath:index_path)
      40
    end

    def tableView(table_view, numberOfRowsInSection: section)
      @data.count
    end    

    CELLID = 'cell_identifier'
    def tableView(tableView, cellForRowAtIndexPath: indexPath)
      cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
        cell = HomeworkCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
        cell.createNameLabel(@data[indexPath.row])
      end

      cell.no_button.when_tapped do 
        updateSmallStepStatuses(@data[indexPath.row], 'no')
        cell.no_button.setBackgroundImage(@no_button_pressed_image, forState: UIControlStateNormal)
        cell.yes_button.setBackgroundImage(@yes_button_image, forState: UIControlStateNormal)
      end

      cell.yes_button.when_tapped do 
        updateSmallStepStatuses(@data[indexPath.row], 'yes')
        cell.yes_button.setBackgroundImage(@yes_button_pressed_image, forState: UIControlStateNormal)
        cell.no_button.setBackgroundImage(@no_button_image, forState: UIControlStateNormal)
      end
      cell
    end

    def tableView(tableView, didSelectRowAtIndexPath: indexPath)
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      name = @data[indexPath.row]['name']
      tableView.reloadData
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
      container_frame = @scroll_view.frame
      container_frame.origin.y -= 100

      # animate the replacement of the current frame with the new one
      UIView.animateWithDuration(0.3,
        animations: lambda {
          @scroll_view.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = true
        }
      )
      @done_btn.enabled = false
    end

    def textViewDidEndEditing(textView)
      @comments = textView.text

      container_frame = @scroll_view.frame
      container_frame.origin.y += 100

      UIView.animateWithDuration(0.3,
        animations: lambda {
          @scroll_view.frame = container_frame
        },
        completion: lambda { |finished|
          @offset = false
        }
      )

      @done_btn.enabled = true

    end

    def updateSmallStepStatuses(small_step, status)
      case status
      when 'no'
        unless @no_small_steps.include? small_step
          @no_small_steps << small_step
        end

        if @yes_small_steps.include? small_step
          @yes_small_steps.delete(small_step)
        end
      when 'yes'
        unless @yes_small_steps.include? small_step
          @yes_small_steps << small_step
        end

        if @no_small_steps.include? small_step
          @no_small_steps.delete(small_step)
        end
      else
      end
    end


    def cell_identifier
      @@cell_identifier ||= 'CELL_IDENTIFIER'
    end

    def createCheckIns(small_steps, status)
      data = {
        week_id: @week[:id],
        date: @date,
        status: status,
        small_steps: small_steps,
        comments: @comments
      }

      unless @is_update
        CheckIn.create(data) do |success|
          if success
            NSLog("Created check in with status #{ status }")
          else
            App.alert("There was an error")
            NSLog("Error creating check in with status #{ status }")
          end
        end
      else
        check_in = @week[:check_in_id]
        puts "CHECK IN: #{ check_in }"
        CheckIn.update(data, check_in) do |success|
          if success
            NSLog("Created check in with status #{ status }")
          else
            App.alert("There was an error")
            NSLog("Error creating check in with status #{ status }")
          end
        end
      end
    end
  end

  class HomeworkCell < UITableViewCell

    attr_accessor :name_label, :no_button, :yes_button

    def createNameLabel(small_step)

      small_step_name = small_step[:name]
      small_step_id = small_step[:id]

      @no_button_image = UIImage.imageNamed('small-no-button')
      @yes_button_image = UIImage.imageNamed('small-yes-button')

      @no_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @no_button.setBackgroundImage(@no_button_image, forState: UIControlStateNormal)

      @yes_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @yes_button.setBackgroundImage(@yes_button_image, forState: UIControlStateNormal)

      @name_label = UILabel.alloc.init
      @name_label.textAlignment = UITextAlignmentLeft
      @name_label.font = UIFont.boldSystemFontOfSize(12)
      @name_label.color = UIColor.blackColor
      @name_label.text = small_step_name

      self.contentView.addSubview(@no_button)
      self.contentView.addSubview(@yes_button)
      self.contentView.addSubview(@name_label)

      self
    end

    def layoutSubviews
      super

      contentRect = self.contentView.bounds
      boundsX = contentRect.origin.x

      height = self.contentView.height

      @no_button.frame = CGRectMake(boundsX+10, height/2 - 13.5, 40, 25)
      @yes_button.frame = CGRectMake(boundsX+55, height/2 - 13.5, 40, 25)
      @name_label.frame = CGRectMake(boundsX+100, height/2 - 13.5, 200, 25)

    end
  end
end
