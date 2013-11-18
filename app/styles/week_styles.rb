Teacup::Stylesheet.new :schedule_styles do

  style :main_view,
    frame: [[0,TOP_BELOW_MM_NAV], ["100%", "100% - #{TOP_BELOW_MM_NAV}"]]

  style UILabel,
    backgroundColor: UIColor.whiteColor,
    font: UIFont.systemFontOfSize(10)
end
