module Screen
 class DayScreen < PM::Screen

    title ''

    def loadView
      views = NSBundle.mainBundle.loadNibNamed "day_view", owner:self, options:nil
      self.view = views[0]
    end

    def viewDidLoad

    end
  end
end
