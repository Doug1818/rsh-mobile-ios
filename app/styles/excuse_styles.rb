Teacup::Stylesheet.new :excuse_styles do
  style :excuse_nav,
    # backgroundColor: UIColor.blackColor,
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

  # Temporary hack for drawer nav_back
  style :nav_back,
    # backgroundColor: UIColor.blackColor,
    backgroundColor: UIColor.clearColor,
    frame: [[0, 0], [30, "100%"]],
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)

  style :nav_back_btn,
    # backgroundColor: UIColor.redColor,
    backgroundColor: UIColor.clearColor,
    width: 30,
    height: '100%'
end
