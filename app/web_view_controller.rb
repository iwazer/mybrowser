# -*- coding: utf-8 -*-
class WebViewController < UIViewController
  def viewDidLoad
    super

    @title_view = self.navigationItem.titleView

    @web_view = UIWebView.new
    self.view = @web_view

    create_navi
    setup_gesture

    show_start_page
  end

  def create_navi
    @progress = UIProgressView.new

    @wview_proxy = NJKWebViewProgress.new
    @web_view.delegate = @wview_proxy
    @wview_proxy.webViewProxyDelegate = self
    @wview_proxy.progressDelegate = self

    frame = [[0.0, 0.0], [300.0, self.navigationController.navigationBar.bounds.size.height]]
    @menu = SINavigationMenuView.alloc.initWithFrame(frame, title:"...")
    @menu.displayMenuInView(self.view)
    @menu.items = "再読み込み", "ブックマーク"
    @menu.delegate = self
    self.navigationItem.titleView = @menu
  end

  # for SINavigationMenuDelegate
  def didSelectItem menu, atIndex:index
    case index
    when 0 # 再読込
      @web_view.reload
    when 1 # ブックマーク
    else
      NSLog("Unknown menu pressed...: %@", index)
    end
  end

  def show_start_page
    url = NSURL.URLWithString "http://www.google.co.jp/"
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

  def webViewProgress webViewProgress, updateProgress:progress
    @progress.progress = progress
  end

  def webViewDidStartLoad webView
    @progress.progress = 0.0
    self.navigationItem.titleView = @progress
  end

  def webViewDidFinishLoad webView
    self.navigationItem.titleView = @menu
    @menu.setTitle(document_title)
  end

  def webView webView, didFailLoadWithError:error
    webViewDidFinishLoad(webView)
  end

  def document_title
    @web_view.stringByEvaluatingJavaScriptFromString("document.title")
  end
end
