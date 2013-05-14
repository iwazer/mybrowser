# -*- coding: utf-8 -*-
module HatenaBookmark
  class << self
    def invoke url, title
      hatenaUrl = NSURL.URLWithString(mkurl(url, title))
      if UIApplication.sharedApplication.canOpenURL(hatenaUrl)
        UIApplication.sharedApplication.openURL(hatenaUrl)
      end
    end

    def mkurl url, title
      "hatenabookmark:/entry?url=%s&title=%s&backurl=%s&backtitle=%s" % [
          url.uriEncode,
          title.uriEncode,
          "iwazer-mybrowser:/".uriEncode,
          "mybrowserに戻る".uriEncode]
    end
  end
end
