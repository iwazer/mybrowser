# -*- coding: utf-8 -*-
class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NSUserDefaults.standardUserDefaults.registerDefaults("UserAgent" =>
      "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 " +
      "iwazer.MyBrowser/0.1")
    PocketAPI.sharedAPI.setConsumerKey("POCKET-CONSUMER-KEY".info_plist)
    return if App.test?

    true
  end

  def applicationDidBecomeActive application
    #pasteboard
  end

  def pasteboard
    @pasteboard ||= load_pasteboard
  end

  def load_pasteboard
    defaults = NSUserDefaults.standardUserDefaults
    Pasteboard.new(LruCache.restore(defaults["pasteboard_cache"]))
  end

  def applicationDidEnterBackground application
    defaults = NSUserDefaults.standardUserDefaults
    defaults["pasteboard_cache"] = LruCache.serialize(@pasteboard.instance_variable_get('@cache'))
  end

  def application application, openURL:url, sourceApplication:source, annotation:annotation
    unless PocketAPI.sharedAPI.handleOpenURL(url)
      return false
    end
    true
  end
end
