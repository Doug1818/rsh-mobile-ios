class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_push_notification(notification, launched)
    App.alert("#{notification}")
  end

  def on_load(app, options)
    Parse.setApplicationId("BWeoNOvfNYguBpxpzsv6PY7qbXEZtOIWDeiPrPBx", clientKey:"JD5CG55qYa6GoFEcv7SgvgPGJdFQfvOExlifIl40")
    register_for_push_notifications :badge, :sound, :alert, :newsstand

    open_screen RootScreen.new(nav_bar: true)
  end

  def on_unload
    unregister_for_push_notifications
  end

  def on_push_registration(token, error)
    PFPush.storeDeviceToken(token)
    PFPush.subscribeToChannelInBackground("test")
  end
end
