module Screen
 class SupportScreen < PM::Screen

    TAGS = { container_view: 1, support_title: 2, support_info: 3, send_feedback: 4, faq_info: 5, faq_link: 6 }

    def on_load
      self.title = ''
      @views = NSBundle.mainBundle.loadNibNamed "support", owner:self, options:nil
    end

    def will_appear
      super

      @view_is_set_up ||= begin

        view.subviews.each &:removeFromSuperview
        self.view = @views[0]

        @support_title = view.viewWithTag TAGS[:support_title]
        @support_title.sizeToFit

        @support_info = view.viewWithTag TAGS[:support_info]
        @support_info.sizeToFit

        @send_feedback = view.viewWithTag TAGS[:send_feedback]
        @send_feedback.titleLabel.font = UIFont.boldSystemFontOfSize(18)
        @send_feedback.setTitleColor(UIColor.orangeColor, forState: UIControlStateNormal)

        @send_feedback.when_tapped do 
          url = 'mailto://contact@rightsidehealth.com'
          UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
        end

        @faq_info = view.viewWithTag TAGS[:faq_info]
        @faq_info.sizeToFit

        @faq_link = view.viewWithTag TAGS[:faq_link]
        @faq_link.titleLabel.font = UIFont.boldSystemFontOfSize(18)
        @faq_link.setTitleColor(UIColor.orangeColor, forState: UIControlStateNormal)

        @faq_link.when_tapped do 
          url = 'http://rightsidehealth.com/support'
          UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
        end
      end
    end
  end
end
