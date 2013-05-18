# -*- coding: utf-8 -*-
class WebViewController < UIViewController
  attr_writer :goto_url

  def viewDidLoad
    super
    @pasteboard = App.delegate.pasteboard

    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector:'applicationDidBecomeActive',
                                                   name:UIApplicationDidBecomeActiveNotification,
                                                   object:nil)

    @title_view = self.navigationItem.titleView

    @web_view = UIWebView.new
    @web_view.scalesPageToFit = true
    self.view = @web_view
    @scrollViewContentOffsetYThreshold = 0

    create_navi
    setup_gesture

    show_page "http://www.google.co.jp/"
  end

  def create_navi
    @progress = UIProgressView.new

    @wview_proxy = NJKWebViewProgress.new
    @web_view.delegate = @wview_proxy
    @wview_proxy.webViewProxyDelegate = self
    @wview_proxy.progressDelegate = self
    @wview_proxy.progressBlock = ->(progress) { @progress.progress = progress }

    frame = [[0.0, 0.0], [300.0, self.navigationController.navigationBar.bounds.size.height]]
    @menu = SINavigationMenuView.alloc.initWithFrame(frame, title:"...")
    @menu.displayMenuInView(self.view)
    @menu.items = "設定","再読み込み", "ブックマークに保存", "ブックマークから選択", "はてなブックマークに送る"
    @menu.delegate = self
    self.navigationItem.titleView = @menu

    @web_view.scrollView.delegate = self
  end

  # for SINavigationMenuDelegate
  def didSelectItem menu, atIndex:index
    case index
    when 0 # 設定
      show_settings
    when 1 # 再読込
      @web_view.reload
    when 2 # ブックマークに保存
      store_bookmark if @current_url
    when 3 # ブックマークから選択
      show_bookmarks
    when 4 # はてなブックマークに送る
      invoke_hatena_bookmark
    else
      NSLog("Unknown menu pressed...: %@", index)
    end
  end

  def show_page url
    url = NSURL.URLWithString url if url.is_a?(String)
    req = NSURLRequest.requestWithURL url
    @web_view.loadRequest req
  end

  ### Gesture Handling

  def setup_gesture
    setup_swipe_gesture UISwipeGestureRecognizerDirectionLeft
    setup_swipe_gesture UISwipeGestureRecognizerDirectionRight
  end

  def setup_swipe_gesture direction
    gesture = case direction
    when UISwipeGestureRecognizerDirectionLeft
      self.instance_variable_set('@swipeLeftGesture',
        UISwipeGestureRecognizer.alloc.initWithTarget(self,
        action:"handleSwipeLeftGesture:"))
    when UISwipeGestureRecognizerDirectionRight
      self.instance_variable_set('@swipeRightGesture',
        UISwipeGestureRecognizer.alloc.initWithTarget(self,
        action:"handleSwipeRightGesture:"))
    end
    gesture.direction = direction
    gesture.delegate = self
    gesture.numberOfTouchesRequired = 2
    @web_view.addGestureRecognizer(gesture)
  end

  def handleSwipeLeftGesture sender
    if @web_view.canGoBack
      @web_view.goBack
    end
  end

  def handleSwipeRightGesture sender
    if @web_view.canGoForward
      @web_view.goForward
    end
  end

  # ページ自体が横スクロールする場合も有効にする
  def gestureRecognizer gestureRecognizer,
    shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer
    true
  end

  ### WebView and Progres Delegater

  def webViewDidStartLoad webView
    @progress.progress = 0.0
    self.navigationItem.titleView = @progress
  end

  def webViewDidFinishLoad webView
    self.navigationItem.titleView = @menu
    update_title
  end

  def update_title
    @menu.setTitle(document_title)
  end

  def webView webView, didFailLoadWithError:error
    webViewDidFinishLoad(webView)
  end

  def webView webview, shouldStartLoadWithRequest:request, navigationType:navigationType
    @current_url = request.mainDocumentURL.absoluteString
  end

  def document_title
    @web_view.stringByEvaluatingJavaScriptFromString("document.title")
  end

  ### UIViewController

  def viewWillAppear animated
    super
    navigation_bar_position
  end

  def scrollViewWillBeginDragging scrollView
    @scroll_begin_point = scrollView.contentOffset
  end

  def scrollViewDidScroll scrollView
    navigation_bar_position
  end

  def navigation_bar_position
    if @scroll_begin_point and @web_view.scrollView
      if @scroll_begin_point.y < @web_view.scrollView.contentOffset.y
        self.navigationController.navigationBarHidden = true unless self.navigationController.navigationBarHidden?
        App.shared.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationFade)
      else
        App.shared.setStatusBarHidden(false, withAnimation:UIStatusBarAnimationFade)
        self.navigationController.navigationBarHidden = false if self.navigationController.navigationBarHidden?
      end
    end
  end

  ### Bookmark

  def store_bookmark
    BookmarkStore.shared.add do |bookmark|
      bookmark.title = document_title
      bookmark.memo = ''
      bookmark.url = @current_url
      bookmark.created_at = Time.now
      bookmark.updated_at = Time.now
    end
  end

  def show_bookmarks
    @bookmarks_controller = BookmarksController.new
    @bookmarks_controller.title = "ブックマーク"
    @bookmarks_controller.delegate = self

    self.navigationController.pushViewController(@bookmarks_controller, animated:true)
  end

  def viewDidAppear animated
    super

    if @goto_url
      show_page @goto_url
      @goto_url = nil
    end
  end

  ### on Activate Notification

  def applicationDidBecomeActive
    url = @pasteboard.url.try(:absoluteString)
    if url
      alert = UIAlertView.alloc.initWithTitle("クリップボードにURLがあります",
                                              message: "#{url}を表示しますか？",
                                              delegate: self,
                                              cancelButtonTitle: "キャンセル",
                                              otherButtonTitles: "表示",nil)
      alert.instance_variable_set('@url', url)
      alert.show
    end
  end

  def alertView alertView, clickedButtonAtIndex:buttonIndex
    case buttonIndex
    when 1
      show_page alertView.instance_variable_get('@url')
    end
  end

  ### Settings

  def show_settings
    @settings_controller = SettingsController.alloc.initWithStyle(UITableViewStyleGrouped)
    @settings_controller.title = "設定"
    @settings_controller.delegate = self

    self.navigationController.pushViewController(@settings_controller, animated:true)
  end

  ### invoke Hatena Bookmark

  def invoke_hatena_bookmark
    HatenaBookmark.invoke @current_url, document_title
  end
end
