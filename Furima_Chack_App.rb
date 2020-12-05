# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
require 'ruby_jard'
require 'selenium-webdriver'
require './main'
require './check_list'


@wait = Selenium::WebDriver::Wait.new(:timeout => 180000)
@d = Selenium::WebDriver.for :chrome
# チェック用のドライバー

@d.manage.timeouts.implicit_wait = 3

# 1つ目のウィンドウのID
@window1_id = @d.window_handle
# 2つ目のウィンドウを開く
@d.execute_script( "window.open()" )
# 2つ目のウィンドウのIDを取得
@window2_id = @d.window_handles.last
@d.switch_to.window(@window1_id)


#basic認証のidとpass
b_id = "admin"
b_password = "1111"
@http ="http://#{b_id}:#{b_password}@"
# 受講生の@URLをhttp://以降から記入

# @url = "#{@http}afternoon-bayou-26262.herokuapp.com/"
@url = "http://localhost:3000/"


@item_image = "/Users/tech-camp/projects/furima_checkApp/photo/coat.jpg"
@item_image2 = "/Users/tech-camp/projects/furima_checkApp/photo/sunglass.jpg"


@nickname = "kusunnjyun"
@email = "divssd16s27@co.jp"
@password = "aaa111"
@first_name = "愛"
@last_name= "不時着"
@first_name_kana = "アイ"
@last_name_kana = "フジチャク"

@nickname2 = "class"
@email2 = "dssaf06s27@co.jp"
@first_name2 = "梨泰"
@user_last_name2 = "院"
@first_name_kana2 = "イテウォン"
@last_name_kana2 = "クラス"

@nickname3 = "player"
@email3 = "aaaabbbb1112@co.jp"
@first_name3 = "ランバ"
@user_last_name3 = "ラル"
@first_name_kana3 = "ランバ"
@last_name_kana3 = "ラル"




@item_image_name = "coat.jpg"
@item_name = "コート"
@item_info = "今年イチオシのトレンチコート"
@item_info_re = "昨年イチオシのトレンチコート"
@value = '2'
@item_price = 40000
# 購入ページのURLを直接入力でリダイレクトされるかのチェック用
@order_url_coat = ""


@item_name2 = "サングラス"
@item_info2 = "限定5品のサングラス"
@item_price2 = 30000
@order_url_glasses = ""

@card_number = 4242424242424242
@card_exp_month = 10
@card_exp_year = 30
@card_cvc = 123
@postal_code = "965-0873"
@prefecture = "福島県"
@city = "会津若松市"
@addresses = "追手町１−１"
@phone_number = "02089001111"

@blank = "1"

@select_index = 1

# チェック項目の結果や詳細を保存しておく配列
# チェック項目の内容はハッシュ 
# {チェック番号： 3 , チェック合否： "〇" , チェック内容： "〇〇をチェック" , チェック詳細： "○○×"}
@check_log = []


begin
    main()
ensure
    if @check_log.length > 0
        @check_log.each { |check|
            puts "■チェック番号：" + check["チェック番号"].to_s + "\n"
            print "■チェック合否：#{check["チェック合否"]}\n"
            print "■チェック内容：\n#{check["チェック内容"]}\n"
            print "■チェック詳細：\n#{check["チェック詳細"]}\n"
        }
    end

    puts $!
    puts $@
end


