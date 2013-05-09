class AppDelegate
  attr_reader :paste_url_cache

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NSUserDefaults.standardUserDefaults.registerDefaults("UserAgent" => "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 iwazer.MyBrowser/0.1")
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @web_view_controller = WebViewController.new

    root_view_controller = UINavigationController.alloc.initWithRootViewController(@web_view_controller)
    @window.rootViewController = root_view_controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end

  def applicationDidBecomeActive application
    defaults = NSUserDefaults.standardUserDefaults
    s = defaults["paste_url_cache"]
    puts s
    @paste_url_cache = Cache.restore(s)
  end

  def applicationDidEnterBackground application
    defaults = NSUserDefaults.standardUserDefaults
    s = Cache.serialize(@paste_url_cache)
    puts s
    defaults["paste_url_cache"] = s
  end
end
