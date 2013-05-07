# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'mybrowser'
  app.version = '1.0.1'
  app.short_version = '1'
  app.deployment_target = '5.0'
  app.identifier = 'com.iwazer.mybrowser'
  app.frameworks += ['CoreData']
  app.codesign_certificate = ENV['CODESIGN_CERTIFICATE']
  app.provisioning_profile = ENV['PROVISIONING_PROFILE']
  app.icons = ["appicon512.png","appicon144.png","appicon144.png"]
  app.prerendered_icon = true
  app.testflight.sdk = 'vendor/TestFlight'
  app.testflight.api_token = ENV['MYBROWSER_TF_API_TOKEN']
  app.testflight.team_token = ENV['MYBROWSER_TF_TEAM_TOKEN']
  app.testflight.distribution_lists = ENV['MYBROWSER_TF_DISTRIBUTION_LISTS'].split(',')

  app.pods do
    pod 'NJKWebViewProgress', git: 'https://github.com/ninjinkun/NJKWebViewProgress.git', tag: 'v0.1.5'
    pod 'SINavigationMenuView', git: 'https://github.com/iwazer/NavigationMenu.git', tag: 'v1.0.3'
  end
end
