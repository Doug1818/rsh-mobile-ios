Teacup::Stylesheet.new :week_styles do
  style :main_view,
    frame: [[0,TOP_BELOW_MM_NAV], ["100%", "100% - #{TOP_BELOW_MM_NAV}"]]
    # frame: [[0,65], ["300", "300"]]

  style :program_nav,
    frame: [[0, "100% - 58.5"], ["100%", 58.5]],
    backgroundColor: "#f1f2f2".to_color,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :day_btn,
    center_x: '50% - 52',
    center_y: '50%',
    width: 27,
    height: 27,
    backgroundImage: UIImage.imageNamed("day-view-btn")

  style :week_btn,
    center_x: '50%',
    center_y: '50%',
    width: 27,
    height: 27,
    backgroundImage: UIImage.imageNamed("week-view-btn")

  style :month_btn,
    center_x: '50% + 52',
    center_y: '50%',
    width: 27,
    height: 27,
    backgroundImage: UIImage.imageNamed("month-view-btn")
end
