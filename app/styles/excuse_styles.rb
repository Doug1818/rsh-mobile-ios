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
end
