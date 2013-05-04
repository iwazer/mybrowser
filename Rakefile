# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'mybrowser'
  app.frameworks += ['CoreData']
  app.codesign_certificate = ENV['CODESIGN_CERTIFICATE']
  app.provisioning_profile = ENV['PROVISIONING_PROFILE']

  app.pods do
    pod 'NJKWebViewProgress'
    pod 'SINavigationMenuView', :git => 'https://github.com/iwazer/NavigationMenu.git', :tag => 'v1.0.3'
  end
end
