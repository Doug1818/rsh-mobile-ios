# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require "rubygems"
require 'bundler'
Bundler.require

require 'bubble-wrap/http'
require 'bubble-wrap/camera'
require 'sugarcube'

Motion::Project::App.setup do |app|
  app.name = 'rshdevelopment'
  app.identifier = 'com.rsh.rshdevelopment'
  app.codesign_certificate = 'iPhone Developer: Adam Rubin (59S96JTU24)'
  app.provisioning_profile = 'provisioning/Barbershop_Labs_provisioning_profile.mobileprovision'

  app.interface_orientations = [:portrait]
  app.device_family = [:iphone]

  app.pods do
    pod 'MMDrawerController', '~> 0.4.0'
  end
end