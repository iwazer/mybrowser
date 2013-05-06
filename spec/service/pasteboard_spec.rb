# -*- coding: utf-8 -*-
describe Pasteboard do
  describe "nilの場合" do
    before do
      Pasteboard.clear
    end
    it "nilを返す" do
      Pasteboard.url.should.equal nil
    end
  end

  describe "Stringの場合" do
    describe "blankの場合" do
      describe "空文字列の場合" do
        before do
          Pasteboard.setValue ""
        end
        it "nilを返す" do
          Pasteboard.url.should.equal nil
        end
      end
      describe "スペースのみの場合" do
        before do
          Pasteboard.setValue "  "
        end
        it "nilを返す" do
          Pasteboard.url.should.equal nil
        end
      end
    end

    describe "不正なURLの場合" do
      before do
        Pasteboard.setValue "abc"
      end
      it "nilを返す" do
        Pasteboard.url.should.equal nil
      end
    end

    before do
      @actual = "http://www.iwazer.com/~iwazawa/"
      Pasteboard.setValue @actual
    end
    it "NSURLを返す" do
      Pasteboard.url.class.should.equal NSURL
    end
    it "与えた文字列をNSString化したものである" do
      Pasteboard.url.absoluteString.should.equal @actual
    end
  end
end
