# -*- coding: utf-8 -*-
class WebViewController < UIViewController
  def viewDidLoad
    super

    self.title = "..."
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

    self.navigationItem.rightBarButtonItem = create_action
  end

  def create_action
    @action_bar_button ||= UIBarButtonItem.alloc.
      initWithBarButtonSystemItem(UIBarButtonSystemItemAction,
                                  target:self, action:'menu_action:')
    @action_bar_button
  end

  def menu_action sender
    @action_sheet ||= UIActionSheet.alloc.initWithTitle("アクション",
                                                        delegate: self,
                                                        cancelButtonTitle: "キャンセル",
                                                        destructiveButtonTitle: nil,
                                                        otherButtonTitles: "再読みこみ",
                                                                           "ブックマーク",
                                                                           nil)
    @action_sheet.showInView self.view
  end

  def actionSheet actionSheet, clickedButtonAtIndex: buttonIndex
    case buttonIndex
    when 0 # 再読込
      @web_view.reload
    when 1 # ブックマーク
    when 2 # キャンセル
    else
      puts buttonIndex
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
    self.navigationItem.titleView = @title_view
    self.title = document_title
  end

  def webView webView, didFailLoadWithError:error
    webViewDidFinishLoad(webView)
  end

  def document_title
    @web_view.stringByEvaluatingJavaScriptFromString("document.title")
  end
end
