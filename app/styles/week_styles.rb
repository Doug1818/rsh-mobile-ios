Teacup::Stylesheet.new :week_styles do
  style :main_view,
    frame: [[0,TOP_BELOW_MM_NAV], ["100%", "100% - #{TOP_BELOW_MM_NAV}"]],
    # backgroundColor: "#ffa721".to_color
    backgroundColor: "#000000".to_color


  style UILabel,
    backgroundColor: UIColor.whiteColor,
    font: UIFont.systemFontOfSize(10)
end
