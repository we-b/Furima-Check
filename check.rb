# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
# require 'ruby_jard'
require 'selenium-webdriver'
require './main'
require './check_list'
# ランダム文字列の生成ライブラリ
require 'securerandom'

# httpリクエストの実行に必要なライブラリ
require "net/http"
require "json"
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
@wait = Selenium::WebDriver::Wait.new(:timeout => 90)
@d = Selenium::WebDriver.for :chrome
#@d = Selenium::WebDriver.for :chrome, options: options


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
#@url_ele = "afternoon-bayou-26262.herokuapp.com/"
@url_ele = "localhost:3000/"

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

# 新規登録等での繰り返し登録テスト用アカウント
@nicknam4 = "lifecoach_test_user4"
@email4 = "user4_#{randm_word}@co.jp"
@first_name4 = "ニコラ"
@last_name4 = "テスラ"
@first_name_kana4 = "ニコラ"
@last_name_kana4 = "テスラ"


@password = "aaa111" #パスワードは全ユーザー共通
@password_short = "aa11" #6文字以下
@password_string = "aaaaaa"
@password_integer = "111111"


# 出品商品情報
@item_image_name = "coat.jpg"
@item_name = "コート"
@item_info = "今年イチオシのトレンチコート"
@item_info_re = "昨年イチオシのトレンチコート"
@value = '2'
@item_price = 40000
@item_image = "/Users/tech-camp/development/Furima-Check/photo/coat.jpg"
@item_category_word = ""
@item_status_word = ""
@item_shipping_fee_status_word = ""
@item_prefecture_word = ""
@item_scheduled_delivery_word = ""


# 購入ページのURLを直接入力でリダイレクトされるかのチェック用
# 売却済商品の購入ページURL
@order_url_coat = ""
# user1によるコート情報編集画面のURL
# 売却済商品の編集ページURL
@edit_url_coat = ""

# 以下のURL商品はuser2が出品したサングラス = login_user2_item_new_2ndメソッド内で行われる
# 商品の購入ページURL
@order_url_glasses = ""
# 商品の編集ページURL
@edit_url_glasses = ""

# ユーザー新規登録画面,出品画面,購入画面で表示されるエラーログを保存しておくハッシュ
@error_log_hash = {}

@item_name2 = "サングラス"
@item_info2 = "限定5品のサングラス"
@item_price2 = 3005
@item_image2 = "/Users/tech-camp/development/Furima-Check/photo/sunglass.jpg"


@item_name3 = "マグロ(時価)"
@item_info3 = "価格の限界に挑戦中"
@item_price3 = 299
@item_image3 = "/Users/tech-camp/development/Furima-Check/photo/tuna.jpg"
@item_image_name3 = "tuna.jpg"

# 購入時のカード情報
@card_number = 4242424242424242
@card_expiry = 1030
@card_cvc = 123
@postal_code = "965-0873"
@prefecture = "福島県"
@city = "会津若松市"
@addresses = "追手町１−１"
@phone_number = "02089001111"
@postal_code_error = "96500873"
@phone_number_error = "02089-01111"

@blank = "1"

@select_index = 1

# チェック項目の結果や詳細を保存しておく配列
# チェック項目の内容はハッシュ 
# {チェック番号： 3 , チェック合否： "〇" , チェック内容： "〇〇をチェック" , チェック詳細： "○○×"}
@check_log = []

# 出力文章(メインチェック番号) = [1-001]等のチェック
# @puts_num_array = []
# [[30配列], [], [], .....]
@puts_num_array = Array.new(9).map{Array.new(30, false)}

#各チェックのフラグ変数
@flag_4_001 = 0;

begin
    main()
ensure

    # メインチェック番号の出力([1-001]系のチェック)
    puts "↓↓↓ 【[1-001]系のチェックの詳細】 ↓↓↓"

    # 先にfor文に渡すチェック番号配列の長さを整数を生成しておく
    for_end_num = @puts_num_array.length
    for_end_num -= 1
    # index = 0はその他出力情報配列なのでindex = 1から出力していく
    for i in 1..for_end_num
        # 各セクション配列の中身を全てループ処理する
        @puts_num_array[i].each{|check|
            # チェック内容が格納されている時だけ出力する
            if check != false
                puts check
            end
        }
    end

    # チェック番号の詳細を出力する
    puts "\n\n\n↓↓↓ 【チェック番号の◯×】 ↓↓↓"
    if @check_log.length > 0
        # 全てのチェック番号を取得して配列にいれる
        check_log_num_array = @check_log.map { |h| h["チェック番号"] }
        # チェック番号1~50までを出力する
        for i in 1..50
            # 出力したいチェック番号の配列indexを取得
            index_num = check_log_num_array.index(i)
            # 出力番号がなかったら何もしない
            if index_num != nil
                puts "チェック番号" + @check_log[index_num]["チェック番号"].to_s + "： " + @check_log[index_num]["チェック合否"] + "\n"
            end
        end
    end


    # チェック番号の詳細を出力する
    puts "\n\n\n↓↓↓ 【チェック番号の詳細】 ↓↓↓"
    if @check_log.length > 0
        # 全てのチェック番号を取得して配列にいれる
        check_log_num_array = @check_log.map { |h| h["チェック番号"] }
        # チェック番号1~50までを出力する
        for i in 1..50
            # 出力したいチェック番号の配列indexを取得
            index_num = check_log_num_array.index(i)
            # 出力番号がなかったら何もしない
            if index_num != nil
                puts "--------------------------------------------------------------------------"
                puts "■チェック番号：" + @check_log[index_num]["チェック番号"].to_s + "\n"
                print "■チェック合否：#{@check_log[index_num]["チェック合否"]}\n"
                print "■チェック内容：\n#{@check_log[index_num]["チェック内容"]}\n"
                print "■チェック詳細：\n#{@check_log[index_num]["チェック詳細"]}\n"
            end
        end
        puts "--------------------------------------------------------------------------"
    end


    # その他情報の出力(URL情報やユーザーアカウントの詳細)
    puts "\n\n\n↓↓↓ 【その他情報の詳細】 ↓↓↓"
    # index = 0はその他出力情報配列
    @puts_num_array[0].each{|check|
        # チェック内容が格納されている時だけ出力する
        if check != false
            puts check
        end
    }

    puts $!
    puts $@
    # 手動確認項目
    puts "【手動での確認が必要な項目一覧】"
    puts "何も編集せずに「更新する」ボタンを押しても、画像無しの商品にならないこと"
    puts "商品名やカテゴリーの情報など、すでに登録されている商品情報は商品情報編集画面を開いた時点で表示されること（商品画像・販売手数料・販売利益に関しては、表示されない状態で良い）"
    puts "配送先の情報として、郵便番号・都道府県・市区町村・番地・電話番号が必須であること"
    puts "入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)"
    puts "-----------92期以降で追加で確認する項目-------------"
    puts "本番環境で投稿した商品画像が、S3に保存されること"
    puts "ユーザー登録、商品出品、商品編集、商品購入時のエラーハンドリングの際、1つのエラーに対して同じエラーメッセージが重複して表示されないこと"
    puts "-----------101期以降で追加で確認する項目-------------"
    puts "エラーハンドリングによって新規登録/ログインページに戻った場合でも、入力済みの項目（パスワード・パスワード確認用以外）は消えないこと"
    puts "エラーハンドリングによって出品ページに戻った場合でも、入力済みの項目（商品画像・販売手数料・販売利益以外）は消えないこと"
    puts "エラーハンドリングによって編集ページに戻った場合でも、入力済みの項目（画像・販売手数料・販売利益以外）は消えないこと"
    puts "エラーハンドリングによって購入ページに戻った場合でも、入力済みの項目（カード番号・有効期限・セキュリティコード以外）は消えないこと"
    puts "商品一覧ページにて商品情報をクリックすると、該当する商品の商品詳細表示ページへ遷移すること"
    puts "建物名は任意であること"
    sleep 30000000000

end