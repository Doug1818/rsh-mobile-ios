Teacup::Appearance.new do

  # UINavigationBar.appearance.setBarTintColor(UIColor.blackColor)
  style UINavigationBar,
    barTintColor: "#ffd114".to_color,
    titleTextAttributes: {
      UITextAttributeTextColor => UIColor.whiteColor
    }

  # style UIBarButtonItem, when_contained_in: UINavigationBar,
  #   tintColor: UIColor.blackColor

  # style UIBarButtonItem, when_contained_in: [UIToolbar, UIPopoverController],
  #   tintColor: UIColor.blackColor

end
