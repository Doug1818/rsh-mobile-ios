Teacup::Stylesheet.new :thank_you_styles do
  style :main_view,
    frame: [[0,0], ["100%", "100%"]]

  style :program_nav,
    frame: [[0, "100% - 58.5"], ["100%", 58.5]],
    backgroundColor: "#f1f2f2".to_color,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin |
                       UIViewAutoresizingFlexibleRightMargin |
                       UIViewAutoresizingFlexibleTopMargin)
end
