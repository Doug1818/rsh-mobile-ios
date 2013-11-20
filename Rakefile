# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
Bundler.require

require 'bubble-wrap/http'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'rsh-mobile-ios'

  app.interface_orientations = [:portrait]
  app.device_family = [:iphone]

  app.pods do
    pod 'MMDrawerController', '~> 0.4.0'
  end
end
