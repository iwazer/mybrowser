# -*- coding: utf-8 -*-
module Pocket
  class << self
    def invoke url
      PocketAPI.sharedAPI.saveURL(url.nsurl, handler:->(api, url, error) {
          if error
            App.alert("ERROR: #{error.localizedDescription}")
          else
            App.alert("the URL was saved successfully")
          end
        })
    end

    def login
      PocketAPI.sharedAPI.loginWithHandler(->(api,error) {
          if error
            App.alert("ERROR: #{error.localizedDescription}")
          else
            App.alert("You are logged in for #{api.username}")
          end
        })
    end
  end
end
