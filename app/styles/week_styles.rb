Teacup::Stylesheet.new :week_styles do
  style :main_view,
    frame: [[0,TOP_BELOW_MM_NAV], ["100%", "100% - #{TOP_BELOW_MM_NAV}"]]
    # backgroundColor: "#ffa721".to_color
    # backgroundColor: "#CCCCCC".to_color

  style :program_nav,
    frame: [[0, "100% - 30"], ["100%", 30]],
    backgroundColor: UIColor.blueColor,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :day_btn,
    center_x: '50% - 30',
    center_y: '50%',
    width: 22,
    height: 22,
    backgroundColor: UIColor.redColor

  style :week_btn,
    center_x: '50%',
    center_y: '50%',
    width: 22,
    height: 22,
    backgroundColor: UIColor.yellowColor

  style :month_btn,
    center_x: '50% + 30',
    center_y: '50%',
    width: 22,
    height: 22,
    backgroundColor: UIColor.purpleColor
end
