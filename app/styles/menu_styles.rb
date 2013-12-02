Teacup::Stylesheet.new :menu_styles do
  style :main_view,
    # backgroundColor: UIColor.whiteColor
    backgroundColor: "#ffa721".to_color

  # style :Location,
  #   frame: [[HORIZ_MARGIN, VERTICAL_MARGIN], ["100%", 22]]

  # style :Sponsors,
  #   frame: [[HORIZ_MARGIN, 38             ], ["100%", 22]]

  # style :Organization,
  #   frame: [[HORIZ_MARGIN, 68             ], ["100%", 22]]

  style :footer,
    frame: [[0,            276            ], ["100%", "100% - 276"]]

  style :made_by,
    frame: [[16,300-TOP_BELOW_MM_NAV], ["100% - 22", 22]],
    backgroundColor: UIColor.whiteColor,
    font: UIFont.boldSystemFontOfSize(12)
end
