Teacup::Appearance.new do

  # UINavigationBar.appearance.setBarTintColor(UIColor.blackColor)
  style UINavigationBar,
    barTintColor: "#ffd114".to_color,
    titleTextAttributes: {
      UITextAttributeFont => UIFont.fontWithName('Trebuchet MS', size:24),
      UITextAttributeTextColor => UIColor.whiteColor
    }

  style UIBarButtonItem, when_contained_in: UINavigationBar,
    tintColor: UIColor.blackColor

  # UINavigationBar.appearanceWhenContainedIn(UIToolbar, UIPopoverController, nil).setColor(UIColor.blackColor)
  style UIBarButtonItem, when_contained_in: [UIToolbar, UIPopoverController],
    tintColor: UIColor.blackColor

end
