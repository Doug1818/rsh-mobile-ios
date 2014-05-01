class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  # If we want to display the notification once the app is launched, or while the app is open, use this
  def on_push_notification(notification, launched)
    # App.alert("NOTIFICATION IS: #{notification}")
  end

  def on_load(app, options)
    NSLog("AppDelegate on_load was called")
    Teacup::Appearance.apply

    Parse.setApplicationId(
      NSBundle.mainBundle.objectForInfoDictionaryKey('PARSE_APPLICATION_KEY'),
      clientKey: NSBundle.mainBundle.objectForInfoDictionaryKey('PARSE_CLIENT_KEY'))
    register_for_push_notifications :badge, :sound, :alert, :newsstand

    open_screen RootScreen.new(nav_bar: true)
  end

  def on_unload
    unregister_for_push_notifications
    
    NSLog("AppDelegate on_unload was called")
  end
  
  def on_activate
    
    # If the user is logged in and they open the app, log the time via the API
    User.get_profile do |success, user|
      if success
        data = { user: { last_sign_in_at: NSDate.date }}
        User.update_profile(data) do |success, user|
          if success
            NSLog("Updated user's last_sign_in_at.")
          else
            NSLog("Error updating user's last_sign_in_at.")
          end
        end
      end
    end
  end

  def on_push_registration(token, error)
    
    NSLog("AppDelegate on_push_registration was called")
    
    PFPush.storeDeviceToken(token)
		App::Persistence[:parse_id] = PFInstallation.currentInstallation.installationId

    PFPush.subscribeToChannelInBackground("all_users")
    PFPush.subscribeToChannelInBackground("user_#{App::Persistence[:user_id]}") if App::Persistence[:user_id]
  end
end
