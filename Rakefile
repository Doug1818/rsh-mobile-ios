# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
Bundler.require

require 'bubble-wrap/http'
require 'bubble-wrap/camera'
require 'sugarcube'
require 'teacup'

Motion::Project::App.setup do |app|
  app.name = 'rshdevelopment'
  app.identifier = 'com.rsh.rshdevelopment'
  app.seed_id = 'Q9HSG7LP5Y'
  app.codesign_certificate = 'iPhone Developer: Adam Rubin (59S96JTU24)'
  app.provisioning_profile = 'provisioning/rsh_provisioning.mobileprovision'

  app.entitlements['application-identifier'] = app.seed_id + '.' + app.identifier
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]
  app.entitlements['aps-environment'] = 'development'
  app.entitlements['get-task-allow'] = true

  app.interface_orientations = [:portrait]
  app.device_family = [:iphone]

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
    'SystemConfiguration',
    'QuartzCore']


  app.vendor_project('vendor/FacebookSDK.framework', :static, :products => ['FacebookSDK'], :headers_dir => 'Headers')
  app.vendor_project('vendor/Parse.framework', :static,
    :products => ['Parse'],
    :headers_dir => 'Headers')

  app.testflight.sdk = 'vendor/TestFlightSDK2.1.3'
  app.testflight.api_token = '2da34e79be5541474fd9216203c82054_MTUyNzY3MjIwMTMtMTItMTkgMTY6MDY6MTEuOTczOTI5'
  app.testflight.team_token = '82084d2a2c8dacf5b8233dd66e362052_MzE2MDI1MjAxMy0xMi0xOSAxNzoyNDoyOS45MTk1NTY'

  app.pods do
    pod 'MMDrawerController', '~> 0.4.0'
  end
end
