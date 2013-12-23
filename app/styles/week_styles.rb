Teacup::Stylesheet.new :week_styles do
  style :main_view,
    frame: [[0,TOP_BELOW_MM_NAV], ["100%", "100% - #{TOP_BELOW_MM_NAV}"]]
    # backgroundColor: "#ffa721".to_color
    # backgroundColor: "#CCCCCC".to_color

  style :program_nav,
    frame: [[0, "100% - 78"], ["100%", 78]],
    backgroundColor: "#f1f2f2".to_color,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :week_view,
    frame: [[0, 0], ["100%", "100%"]],
    backgroundColor: UIColor.greenColor,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :day_info_for_week,
    center_x: '50%',
    center_y: '10%',
    width: '100%',
    height: 50,
    backgroundColor: UIColor.redColor

  style :day_btn,
    center_x: '50% - 52',
    center_y: '50%',
    width: 36,
    height: 36,
    backgroundImage: UIImage.imageNamed("day-view-btn")

  style :week_btn,
    center_x: '50%',
    center_y: '50%',
    width: 36,
    height: 36,
    backgroundImage: UIImage.imageNamed("week-view-btn")

  style :month_btn,
    center_x: '50% + 52',
    center_y: '50%',
    width: 36,
    height: 36,
    backgroundImage: UIImage.imageNamed("month-view-btn")
end
