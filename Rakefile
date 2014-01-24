# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
Bundler.require

require 'bubble-wrap/http'
require 'bubble-wrap/camera'
require 'bubble-wrap/reactor'
require 'sugarcube'
require 'teacup'

Motion::Project::App.setup do |app|
  app.name = 'Steps'
  app.version = '1.1'
  app.identifier = 'com.rightsidehealth.steps'
  app.seed_id = 'G7HZ9FYRPN'

  # Development
  app.codesign_certificate = 'iPhone Developer: Douglas Raicek (58P5EA25ET)'
  app.provisioning_profile = 'provisioning/developmentprovisioning.mobileprovision'
  app.info_plist['PARSE_APPLICATION_KEY'] = "0I8WCIxThhO07OAIeqKDFwAq0rHRXnHxY5auF6KG"
  app.info_plist['PARSE_CLIENT_KEY'] = "QRAhXyWISyBpJmckbiY49a1XtjwlCKhAj2PzMoFR"

  # TestFlight
  # app.codesign_certificate = 'iPhone Distribution: Right Side Technologies, Inc. (G7HZ9FYRPN)'
  # app.provisioning_profile = 'provisioning/adhocdistributionprovisioning.mobileprovision'
  # app.info_plist['PARSE_APPLICATION_KEY'] = "m7UOgUNoihu3JP3Zn9WcShFORaxkoanuTybOWDx8"
  # app.info_plist['PARSE_CLIENT_KEY'] = "dpQ2WWwn2TXjN5pYbCL5laAZSjdd4dfn48LdFx68"

  # Distribution / Production
  # app.provisioning_profile = 'provisioning/distributionprovisioning.mobileprovision'
  # app.info_plist['PARSE_APPLICATION_KEY'] = "m7UOgUNoihu3JP3Zn9WcShFORaxkoanuTybOWDx8"
  # app.info_plist['PARSE_CLIENT_KEY'] = "dpQ2WWwn2TXjN5pYbCL5laAZSjdd4dfn48LdFx68"

  app.entitlements['application-identifier'] = app.seed_id + '.' + app.identifier
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  # Development
  app.entitlements['aps-environment'] = 'development'
  app.entitlements['get-task-allow'] = true

  # Distribution / Production / TestFlight
  # app.entitlements['aps-environment'] = 'production'
  # app.entitlements['get-task-allow'] = false



  app.interface_orientations = [:portrait]
  app.device_family = [:iphone]
  app.icons = ['Icon.png', 'Icon-200.png', 'Icon-72.png', 'Icon-72@2x.png', 'Icon-120.png', 'Icon-200.png', 'Icon-200@2x.png']

  app.libs << '/usr/lib/libz.1.1.3.dylib'
  app.libs << '/usr/lib/libsqlite3.dylib'
  app.frameworks += [
    'AudioToolbox',
    'Accounts',
    'AdSupport',
    'CFNetwork',
    'CoreGraphics',
    'CoreLocation',
    'MobileCoreServices',
    'QuartzCore',
    'Security',
    'Social',
    'StoreKit',
    'SystemConfiguration']


  app.vendor_project('vendor/FacebookSDK.framework', :static, :products => ['FacebookSDK'], :headers_dir => 'Headers')
  app.vendor_project('vendor/Parse.framework', :static, :products => ['Parse'], :headers_dir => 'Headers')

  app.testflight.sdk = 'vendor/TestFlightSDK2.1.3'
  app.testflight.api_token = '2da34e79be5541474fd9216203c82054_MTUyNzY3MjIwMTMtMTItMTkgMTY6MDY6MTEuOTczOTI5'
  app.testflight.team_token = '82084d2a2c8dacf5b8233dd66e362052_MzE2MDI1MjAxMy0xMi0xOSAxNzoyNDoyOS45MTk1NTY'

  # app.info_plist["UIStatusBarStyle"] = "UIStatusBarStyleBlackOpaque"
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.info_plist['UIStatusBarStyle'] = "UIStatusBarStyleDefault"


  app.pods do
    pod 'MMDrawerController', '~> 0.4.0'
    pod 'MNCalendarView', '~> 0.0.1'
  end
end
