class AppDelegate < PM::Delegate
  status_bar false, animation: :none

  # If we want to display the notification once the app is launched, or while the app is open, use this
  def on_push_notification(notification, launched)
    # App.alert("NOTIFICATION IS: #{notification}")
  end

  def on_load(app, options)
    Teacup::Appearance.apply

    Parse.setApplicationId("BWeoNOvfNYguBpxpzsv6PY7qbXEZtOIWDeiPrPBx", clientKey:"JD5CG55qYa6GoFEcv7SgvgPGJdFQfvOExlifIl40")
    register_for_push_notifications :badge, :sound, :alert, :newsstand

    open_screen RootScreen.new(nav_bar: true)
  end

  def on_unload
    unregister_for_push_notifications
  end

  def on_push_registration(token, error)
    PFPush.storeDeviceToken(token)

    PFPush.subscribeToChannelInBackground("all_users")
    PFPush.subscribeToChannelInBackground("user_#{App::Persistence[:user_id]}") if App::Persistence[:user_id]
  end
end
