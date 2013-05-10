class Pasteboard
  def initialize cache=nil
    @cache = cache
    @pasteboard = UIPasteboard.generalPasteboard
  end

  def url
    url = @pasteboard.URL || @pasteboard.string
    url = NSURL.URLWithString url if url.is_a?(String)
    if url and url.absoluteString.valid_url?
      s = url.absoluteString
      if @cache.read(s)
        url = nil
      else
        @cache.store(s, s)
      end
    end
    url
  end

  def setValue value, options={}
    type = options[:type] || "public.utf8-plain-text"
    shared.setValue value, forPasteboardType:type
  end

  def clear
    @pasteboard.items = nil
  end
end
