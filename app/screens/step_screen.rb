class StepScreen < PM::Screen
	attr_accessor :step_id

	def on_load
		self.title = "Step #{self.step_id}"
	end

	def will_appear
		set_attributes self.view, {
			background_color: hex_color("#FFFFFF")
		}
		add UILabel.new, {
			text: "Step Content",
			font: UIFont.systemFontOfSize(32),
			left: 20,
			top: 200,
			width: 280,
			height: 50,
			text_alignment: NSTextAlignmentCenter
		}
	end
end