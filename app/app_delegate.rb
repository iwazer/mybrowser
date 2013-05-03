class AppDelegate
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
end
