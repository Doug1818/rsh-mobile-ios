module Screen
 class Profile < UIViewController

    TAGS = {profile_image: 4, profile_email: 3}
  
    def loadView
      views = NSBundle.mainBundle.loadNibNamed "profile", owner:self, options:nil
      self.view = views[0]
    end

    def viewDidLoad
      profile_email = view.viewWithTag TAGS[:profile_email]

      data = {authentication_token: App::Persistence[:authentication_token]}

      BW::HTTP.get("http://localhost:3000/api/v1/users", { payload: data }) do |response|
        if response.ok?
          json_data = BW::JSON.parse(response.body.to_str)[:data]
          profile_email.text = json_data[:user][:email]
        elsif response.status_code.to_s =~ /40\d/
          App.alert("There was an error")
        else
          App.alert(response.error_message)
        end
      end

      profile_image = view.viewWithTag TAGS[:profile_image]
      profile_image.addTarget self, action: 'chooseProfileImage:', forControlEvents:UIControlEventTouchUpInside
    end

    def chooseProfileImage(sender)
      BW::Device.camera.any.picture(media_types: [:image]) do |result|
        image_view = UIImageView.alloc.initWithImage(result[:original_image])
      end
    end
  end
end


# module Screen
#  class Profile < PM::Screen
#     title 'Profile'

#     def will_appear
#       mm_drawerController.title = title
#     end

#     # stylesheet :schedule_styles
#     # include Teacup::TableViewDelegate

#     def will_appear
#       # move down for nav menu
#       # table_view.top = TOP_BELOW_MM_NAV
#       # table_view.height = table_view.superview.height - table_view.top
#       # set_attributes self.view, background_color: UIColor.blueColor

#       @view_is_set_up ||= begin
#         add UIView.new, {
#           background_color: UIColor.whiteColor,
#           frame: self.bounds
#         }
#         true
#       end

#       @email_label = UILabel.alloc.initWithFrame([[20, 200], [100, 30]])
#       @email_label.text = "Email"
#       @email_label.textColor = UIColor.redColor

#       add @email_label

#       @email_content = UILabel.alloc.initWithFrame([[20, 250], [200, 30]])
#       @email_content.text = "person@somewhere.com"
#       @email_content.backgroundColor = UIColor.lightGrayColor

#       add @email_content
#     end

#     # def table_data
#     #   [{
#     #     cells: [
#     #       { title: "First Name", action: :tapped_first_name },
#     #     ]
#     #   }]
#     # end

#     # def tableView(table_view, viewForHeaderInSection:section)
#     #   UILabel.alloc.init.tap do |view|
#     #     view.backgroundColor = UIColor.clearColor
#     #     view.textColor = BW.rgb_color(239, 69, 67)
#     #     view.textAlignment = NSTextAlignmentCenter
#     #     view.text = section_at_index(section)[:title]
#     #   end
#     # end
#   end
# end
