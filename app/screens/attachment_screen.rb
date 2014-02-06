module Screen
	class AttachmentScreen < PM::WebScreen
		attr_accessor :url

		title "Attachment"

		def on_load
			set_nav_bar_button :right, title: "Done", action: :close_attachment_screen
		end

		def content
			# UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
			NSURL.URLWithString(url)
		end

		def load_failed
			UIAlert.alloc.initWithTitle('Failed to load',
				message: 'Sorry, the attachment failed to load. Please check that you have an internet connection.',
				delegate: nil,
				cancelButtonTitle: 'OK',
				otherButtonTitles: nil
			).show
		end

		def close_attachment_screen
			close
		end
	end
end