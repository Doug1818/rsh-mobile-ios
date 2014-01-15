Teacup::Stylesheet.new :excuse_styles do
  style :main_view,
    frame: [[0,TOP_BELOW_MM_NAV], ["100%", "100% - #{TOP_BELOW_MM_NAV}"]]

  style :excuse_nav,
    frame: [[0, "100% - 58.5"], ["100%", 58.5]],
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :done_btn,
    center_x: '50%',
    center_y: '50%',
    width: 102,
    height: 42,
    backgroundImage: UIImage.imageNamed("done-btn")
end
