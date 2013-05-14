# -*- coding: utf-8 -*-
module HatenaBookmark
  class << self
    def invoke url
      hatenaUrl = NSURL.URLWithString(
        "hatenabookmark:/entry?url=%s&backurl=%s&backtitle=%s",
          url.uriEncode,
          "iwazer-mybrowser:/".uriEncode,
          "mybrowserに戻る".uriEncode)
      if App.canOpenURL(hatenaUrl)
        App.openURL(hatenaUrl)
      end
    end
  end
end
