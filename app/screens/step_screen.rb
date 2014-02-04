class StepScreen < PM::Screen
	attr_accessor :step
	# attr_accessor :date, :week, :is_update, :comments

	def on_load
		@step = self.step
		self.title = "Step #{@step[:id]}"
	end

	def will_appear
		set_attributes self.view, {
			background_color: hex_color("#FFFFFF")
		}
		add UILabel.new, {
			text: @step[:note],
			font: UIFont.systemFontOfSize(32),
			left: 20,
			top: 200,
			width: 280,
			height: 50,
			text_alignment: NSTextAlignmentCenter
		}
	end
end