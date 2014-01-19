#coding : -*-utf-8-*-

require 'rubygems'
require 'tweetstream'
require 'open-uri'
require 'gtk2'
require 'json'

keys = JSON.parse(File.read("./keys/keys.json"))["twitter"]

############################################
# 										   #
# keysディレクトリのexample_keys.jsonの例のように	   #
# keys.jsonを作成してください.			  		   #
# 										   #
# "consumer_key" => コンシューマキー  		   #
# "consumer_secret" => コンシューマシークレット	   #
# "token" => アクセストークン					   #
# "token_secret" => アクセストークンシークレット	   #
# "times" => LTの開催数  					   #
# 										   #
############################################

TweetStream.configure do |cnf| #OAuthに必要な情報類
	cnf.consumer_key = keys["consumer_key"] #コンシューマキー
	cnf.consumer_secret = keys["consumer_secret"] #コンシューマシークレット
	cnf.oauth_token = keys["token"] #OAuthトークン
	cnf.oauth_token_secret = keys["token_secret"] #OAuthトークンシークレット
	cnf.auth_method = :oauth
end

window = Gtk::Window.new
	window.title = "JoshoLT #" + keys["times"]#LTの開催回数をタイトルとして表示

	#windowをdelete_eventに接続
	window.signal_connect("delete_event") do
			Gtk.main_quit#delete_eventが発行されたらメインループを終了
	end

	window.set_size_request(500, 715)#ウィンドウサイズを500*715に設定

#スクロールできるようなウィジェットを生成
scroller = Gtk::ScrolledWindow.new(hadjusment = nil, vadjusment = nil)#上下スクロールできるコンテナウィジェット
	scroller.set_size_request(500, 715)
	scroller.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)


TweetStream::Client.new.track("#JoshoLT") do |status|
	
	

	#tweetを格納した垂直ボックスを作成する
	name = Gtk::Label.new(status.user.name) #ユーザーネーム用ラベル
	screen_name = Gtk::Label.new(status.user.screen_name)#スクリーンネーム用ラベル
	
	icon = Gtk::Image.new(status.user.profile_url)#アイコンの画像を格納するイメージウィジェット

	tweet = Gkt::Label.new(status.text)#ツイート本文を格納するテキストラベル
	tweet.wrap = true#tweetのテキストの自動折り返しをtrueに

	twicell = Gtk::VBox.new(true, 5)#以下２つのボックスを格納する
	names = Gtk::HBox.new(true, 10)#name, screen_nameを格納する
	body = Gtk::HBox.new(false, 5)#icon, tweetを格納する

	#各ウィジェットをボックスに格納
	names.pack_end(name, false, false, 5)
	names.pack_end(screen_name, false, false, 5)

	body.pack_end(icon, false, false, 5)
	body.pack_end(tweet, false, false, 5)

	twicell.pack_end(body, false, false, 5)
	twicell.pack_end(name, false, false, 5)

	#スクローラウィンドにtwicellを格納
	scroller.add_with_viewport(twicell)
	window.add(scroller)
	window.show_all
end