module Screen
  class StepScreen < PM::Screen
  	attr_accessor :step
  	# attr_accessor :date, :week, :is_update, :comments

  	def on_load
  		@step = self.step
  		self.title = "Step Details"
  	end

  	def will_appear
  		set_attributes self.view, {
  			background_color: hex_color("#FFFFFF")
  		}
  		add @note_text = UILabel.new, {
  			text: @step[:note],
  			font: UIFont.systemFontOfSize(16),
  			left: 20,
  			top: 90,
  			width: 280,
  			text_alignment: NSTextAlignmentLeft
  		}
  		@note_text.lineBreakMode = NSLineBreakByWordWrapping;
  		@note_text.numberOfLines = 0;
  		@note_text.sizeToFit

  		notes_height = @note_text.frame.origin.y + @note_text.height

  		@attachments_label = subview(UILabel, :attachments_label)
      @attachments_label.top = notes_height + 50

  		attachment_data = []
  		attachments = @step[:attachments]

      attachments.each do |attachment|
        attachment_data << attachment
      end

      @last_attachment = nil
      attachment_data.each_with_index do |attachment, index|
        instance_variable_set("@attachment_label_#{ index }", "attachment_#{ index }")

        @attachment_var = instance_variable_get("@attachment_label_#{ index }")

        @attachment_var = subview(UIButton.alloc.init, :attachment_button)
        @attachment_var.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
        @attachment_var.titleLabel.font = UIFont.boldSystemFontOfSize(16)
        @attachment_var.setTitleColor(UIColor.orangeColor, forState: UIControlStateNormal)

        title = attachment[:friendly_name]

        @attachment_var.setTitle("#{ title }", forState: UIControlStateNormal)
        @attachment_var.frame = CGRectMake(20, index * 20, 200, 25)
        @attachment_var.top = notes_height + 20 + (30 * index)

        @attachment_var.when_tapped do 
          # url = attachment[:url]
          # UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
          open_modal AttachmentScreen.new(nav_bar: true, url: attachment[:url])
        end
        @last_attachment = @attachment_var
      end

      unless @last_attachment.nil?
        comment_top = @last_attachment.height + @last_attachment.frame.origin.y
      else
        comment_top = @attachments_label.height + @attachments_label.frame.origin.y + 60
      end
  	end
  end
end
