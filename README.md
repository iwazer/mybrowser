# 自分だけのためのブラウザ

SafariもChromeもとても素晴らしい。しかしあとコレがあればなーということがなきにしもあらずなので自分だけのブラウザを作ってみるテスト。

## How to build

```shell
gem install cocoapods 
pod setup
git clone https://github.com/iwazer/mybrowser.git
cd mybrowser
bundle

export CODESIGN_CERTIFICATE='iPhone Developer: ….'
export PROVISIONING_PROFILE='/Users/user/Library/MobileDevice/Provisioning Profiles/DEADBEEF-DEAD-BEEF-DEAD-BEAFDEADBEAF.mobileprovision'
export MYBROWSER_TF_API_TOKEN='<API TOKEN>'
export MYBROWSER_TF_TEAM_TOKEN='<TEAM TOKEN>'
export MYBROWSER_TF_DISTRIBUTION_LISTS='<DIST1,DIST2,DIST3>'

rake
```
