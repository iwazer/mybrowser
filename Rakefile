# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'mybrowser'
  app.version = '1.0.2'
  app.short_version = '1'
  app.deployment_target = '5.1'
  app.identifier = 'com.iwazer.mybrowser'
  app.frameworks += ['CoreData', 'Security']

  app.info_plist['UIMainStoryboardFile'] = 'Storyboard'

  app.codesign_certificate = ENV['CODESIGN_CERTIFICATE'] if ENV['CODESIGN_CERTIFICATE']
  app.provisioning_profile = ENV['PROVISIONING_PROFILE'] if ENV['PROVISIONING_PROFILE']
  app.icons = ["appicon512.png","appicon144.png","appicon144.png"]
  app.prerendered_icon = true
  app.testflight.sdk = 'vendor/TestFlight'
  app.testflight.api_token = ENV['MYBROWSER_TF_API_TOKEN'] if ENV['MYBROWSER_TF_API_TOKEN']
  app.testflight.team_token = ENV['MYBROWSER_TF_TEAM_TOKEN'] if ENV['MYBROWSER_TF_TEAM_TOKEN']
  app.testflight.distribution_lists = ENV['MYBROWSER_TF_DISTRIBUTION_LISTS'].split(',') if ENV['MYBROWSER_TF_DISTRIBUTION_LISTS']

  app.info_plist['POCKET-CONSUMER-KEY'] = ENV['POCKET_CONSUMER_KEY']

  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'com.iwazer.mybrowser',
      'CFBundleURLSchemes' => ['iwazer-mybrowser'] },
    { 'CFBundleURLName' => 'com.readitlater',
      'CFBundleURLSchemes' => ["pocketapp#{ENV['POCKET_CONSUMER_KEY'].split("-")[0]}"] }
  ]

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  app.pods do
    pod 'NJKWebViewProgress'
    pod 'SINavigationMenuView', {
      git: 'https://github.com/iwazer/NavigationMenu.git',
      tag: 'v1.0.3' }
    pod 'PocketAPI'
  end
end
