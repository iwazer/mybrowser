# -*- coding: utf-8 -*-
class WebViewController < UIViewController
  attr_writer :goto_url

  def viewDidLoad
    super

    NSNotificationCenter.defaultCenter.addObserver(self,
                                                   selector:'applicationDidBecomeActive',
                                                   name:UIApplicationDidBecomeActiveNotification,
                                                   object:nil)

    @title_view = self.navigationItem.titleView

    @web_view = UIWebView.new
    @web_view.scalesPageToFit = true
    self.view = @web_view

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
    @menu.items = "再読み込み", "ブックマークに保存", "ブックマークから選択"
    @menu.delegate = self
    self.navigationItem.titleView = @menu
  end

  # for SINavigationMenuDelegate
  def didSelectItem menu, atIndex:index
    case index
    when 0 # 再読込
      @web_view.reload
    when 1 # ブックマークに保存
      store_bookmark if @current_url
    when 2 # ブックマークから選択
      show_bookmarks
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
    @current_url = request.URL.absoluteString
  end

  def document_title
    @web_view.stringByEvaluatingJavaScriptFromString("document.title")
  end

  ### Bookmark

  def store_bookmark
    BookmarkStore.shared.addEntry do |bookmark|
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
    url = Pasteboard.url.absoluteString
    if url
      alert = UIAlertView.alloc.initWithTitle("クリップボードにURLがあります",
                                              message: "#{url}を表示しますか？",
                                              delegate: self,
                                              cancelButtonTitle: "キャンセル",
                                              otherButtonTitles: "表示",nil)
      alert.show
    end
  end

  def alertView alertView, clickedButtonAtIndex:buttonIndex
    case buttonIndex
    when 1
      show_page Pasteboard.url
    end
  end
end
