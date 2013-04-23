class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @web_view_controller = WebViewController.new

    root_view_controller = UINavigationController.alloc.initWithRootViewController(@web_view_controller)
    @window.rootViewController = root_view_controller
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
