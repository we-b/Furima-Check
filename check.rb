# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
require 'ruby_jard'
require 'selenium-webdriver'
require './main'
require './check_list'
# ランダム文字列の生成ライブラリ
require 'securerandom'

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
@b_id = "admin"
@b_password = "2222"

@url_ele = "afternoon-bayou-26262.herokuapp.com/"

# テスト登録用emailのランダム文字列
randm_word = SecureRandom.hex(10) #=> "4a01bbd139f5e94bd249"


# ユーザー情報
@nickname = "lifecoach_test_user1"
@email = "user1_#{randm_word}@co.jp"
@first_name = "愛"
@last_name= "不時着"
@first_name_kana = "アイ"
@last_name_kana = "フジチャク"

@nickname2 = "lifecoach_test_user2"
@email2 = "user2_#{randm_word}@co.jp"
@first_name2 = "梨泰"
@last_name2 = "院"
@first_name_kana2 = "イテウォン"
@last_name_kana2 = "クラス"

@nickname3 = "lifecoach_test_user3"
@email3 = "user3_#{randm_word}@co.jp"
@first_name3 = "ランバ"
@last_name3 = "ラル"
@first_name_kana3 = "ランバ"
@last_name_kana3 = "ラル"

@password = "aaa111" #パスワードは全ユーザー共通



# 出品商品情報
@item_image_name = "coat.jpg"
@item_name = "コート"
@item_info = "今年イチオシのトレンチコート"
@item_info_re = "昨年イチオシのトレンチコート"
@value = '2'
@item_price = 40000
@item_image = "/Users/tech-camp/projects/furima_checkApp/photo/coat.jpg"
@item_category_word = ""
@item_status_word = ""
@item_shipping_fee_status_word = ""
@item_prefecture_word = ""
@item_scheduled_delivery_word = ""


# 購入ページのURLを直接入力でリダイレクトされるかのチェック用
@order_url_coat = ""
# user1によるコート情報編集画面のURL
@edit_url_coat = ""
# ユーザー新規登録画面,出品画面,購入画面で表示されるエラーログを保存しておくハッシュ
@error_log_hash = {}

@item_name2 = "サングラス"
@item_info2 = "限定5品のサングラス"
@item_price2 = 30000
@item_image2 = "/Users/tech-camp/projects/furima_checkApp/photo/sunglass.jpg"
@order_url_glasses = ""

@item_name3 = "マグロ(時価)"
@item_info3 = "価格の限界に挑戦中"
@item_price3 = 299
@item_image3 = "/Users/tech-camp/projects/furima_checkApp/photo/tuna.jpg"
@item_image_name3 = "tuna.jpg"

# 購入時のカード情報
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
            puts "--------------------------------------------------------------------------"
            puts "■チェック番号：" + check["チェック番号"].to_s + "\n"
            print "■チェック合否：#{check["チェック合否"]}\n"
            print "■チェック内容：\n#{check["チェック内容"]}\n"
            print "■チェック詳細：\n#{check["チェック詳細"]}\n"
            puts "--------------------------------------------------------------------------"

        }
    end
    sleep 30000000000
    puts $!
    puts $@
end


