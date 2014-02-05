Teacup::Stylesheet.new :complex_check_in_styles do

  style :scroll_view,
    width: '100%',
    height: '100%',
    autoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

  style :table_view, extends: :flexible_margins,
    scrollEnabled: false,
    separatorStyle: UITableViewCellSeparatorStyleNone,
    width: '100%',
    backgroundColor: UIColor.redColor
 
  style :flexible_margins,
    autoresizingMask: (UIViewAutoresizingFlexibleLeftMargin    | 
                      UIViewAutoresizingFlexibleRightMargin   |
                      UIViewAutoresizingFlexibleTopMargin     |
                      UIViewAutoresizingFlexibleBottomMargin)


  style :multiple_check_in_details_main, extends: :flexible_margins,
    frame: [[0, 0], ["100%", "100%"]],
    backgroundColor: UIColor.whiteColor

  style :side_bar_label, extends: :flexible_margins,
    left: 20,
    width: 200,
    height: 100,
    color: '#7B7C7F'.to_color,
    font: UIFont.boldSystemFontOfSize(18)

  style :homework_label, extends: :side_bar_label,
    text: "Homework",
    top: '10%'

  style :notes_label, extends: :side_bar_label,
    text: "Notes"

  style :notes_text, extends: :flexible_margins,
    left: 20,
    width: '80%',
    height: '100%',
    color: '#7B7C7F'.to_color,
    font: UIFont.systemFontOfSize(12)

  style :attachments_view, extends: :flexible_margins,
    frame: [[0, 0], ["100%", "100%"]]

  style :attachments_label, extends: [:side_bar_label, :flexible_margins],
    text: "Attachments"

  style :attachment_button, extends: :flexible_margins,
    left: 20

  style :multiple_check_in_details_nav, extends: :flexible_margins,
    frame: [[0, "100% - 58.5"], ["100%", 58.5]],
    backgroundColor: UIColor.whiteColor

  style :comments_label, extends: :side_bar_label,
    text: "Comments"
    
  style :comments_view,
    left: 20,
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
