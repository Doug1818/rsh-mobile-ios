module Screen
  class ThankYouScreen < PM::Screen

    stylesheet :thank_you_styles

    def on_load
      @views = NSBundle.mainBundle.loadNibNamed "thank_you_view", owner:self, options:nil
      self.title = ''
    end

    def will_appear
      super

      @view_is_set_up ||= begin
        view.subviews.each &:removeFromSuperview
        self.view = @views[0]
        layout(view, :main_view) do |main_view|
        end
      end
    end

    # After 2 seconds, switch to the Week Screen.
    def on_appear
      d = EM::DefaultDeferrable.new
      d.errback do 
        screen = mm_drawerController.send(:week_screen)
        mm_drawerController.centerViewController = screen
      end
      d.timeout 2 
    end
  end
end
