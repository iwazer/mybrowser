class Pasteboard
  class << self
    def shared
      @pasteboard ||= UIPasteboard.generalPasteboard
    end

    def url
      url = shared.URL || shared.string
      url = NSURL.URLWithString url if url.is_a?(String)
      url if url and url.absoluteString.valid_url?
    end

    def setValue value, options={}
      type = options[:type] || "public.utf8-plain-text"
      shared.setValue value, forPasteboardType:type
    end

    def clear
      shared.items = nil
    end
  end
end
