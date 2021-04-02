# チェック項目のメソッドをまとめているファイル
require './check_list'
# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
 require 'ruby_jard'

# メモ
# 購入時に起こっていたエラー詳細
# item-red-btn = 商品詳細画面での商品の編集 or 購入のボタン
# buy-red-btn  = 購入画面での購入ボタン


def main

  start

  # basic認証が実装されている
  check_14

  @http ="http://#{@b_id}:#{@b_password}@"
# 受講生の@URLをhttp://以降から記入
  @url = @http + @url_ele
  # @url = "http://#{b_id}:#{b_password}@localhost:3000/"

  @d.get(@url)

  # ランダム情報で生成されるユーザー情報を出力する(再度ログインなどをする可能性もあるため)
  print_user_status
  # ユーザー状態：ログアウト
  # 出品：コート = ,サングラス =
  # 購入：コート = ,サングラス =
  # ユーザー状態：ログアウト
  # 出品：コート = なし,サングラス = なし
  # 購入：コート = なし,サングラス = なし

  # ログアウト状態では、ヘッダーに新規登録/ログインボタンが表示されること
  check_1
  # ユーザー状態：user1
  # 出品：コート = なし,サングラス = なし
  # 購入：コート = なし,サングラス = なし
  # ユーザー新規登録
  # メールアドレス未入力
  sign_up_nickname_input
  #パスワード5文字
  sign_up_password_short
  sign_up_password_string
  # チェックがsign_up_retryに組み込まれているのでメソッドで分けたい。
  # 【未実装】数字だけ、文字だけのパスワードで登録できるか検証する。
  #check_23
  # 必須項目を入力して再登録
  sign_up_retry
  # トップメニュー → ログアウトする
  logout_from_the_topMenu
  # ログイン
  login_user1
  # ログイン状態では、ヘッダーにユーザーのニックネーム/ログアウトボタンが表示されること
  check_2
  # ユーザー状態：user1
  # 出品：コート = user1,サングラス = なし
  # 購入：コート = なし,サングラス = なし

  # 出品
  # 価格未入力で出品トライ
  item_new_price_uninput
  # 入力必須項目を全て入力した状態で出品
  item_new_require_input

  # 自分で出品した商品の商品編集(エラーハンドリング)
  item_edit

  # ログアウトしてから商品の編集や購入ができるかチェック
  logout_item_edit_and_buy

  # ユーザー状態：user2
  # 出品：コート = user1,サングラス = なし
  # 購入：コート = user2,サングラス = なし

  # user2で登録 & ログイン
  login_user2
  # user2が商品購入
  login_user2_item_buy

  # 出品者・出品者以外にかかわらず、ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること
  check_16

  # ログイン状態の出品者以外のユーザーが、URLを直接入力して売却済み商品の商品購入ページへ遷移しようとすると、トップページに遷移すること
  check_6

  # 出品者でも、売却済みの商品に対しては「編集・削除ボタン」が表示されないこと
  check_10

  # ログアウト状態のユーザーは、URLを直接入力して売却済みの商品情報編集ページへ遷移しようとすると、ログインページに遷移すること
  check_21


  # 購入後の商品状態や表示方法をチェック
  login_user2_after_purchase_check1


  # ユーザー状態：user2
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = なし

  # user2による出品(サングラス)
  login_user2_item_new

  # ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること
  # サングラス　→　コートの順に出品されているかチェック
  # check_4メソッド内でuser2 → ログアウト状態に移行
  check_4

  # ユーザー状態：ログアウト → user1
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = user1

  # login_user1_item_showメソッドは実行の必要がなくなったためコメントアウト
  # ログアウト → user1でログイン
  # サングラスの購入URL情報を取得
  # login_user1_item_show

  # ユーザー状態：user1 → ログアウト
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = user1

  # ログアウトしたユーザーで購入できるかチェック
  no_user_item_buy_check

  # user2(サングラスの出品者)によるサングラスの画面遷移チェック
  login_user2_after_purchase_check2

  # LCが自動チェックツール実行後に手動で確認しやすいように商品を出品し、商品編集URLと商品購入URLを取得しておく
  # user2による出品(サングラス)→user1でログインして購入画面URLの取得
  login_user2_item_new_2nd

  # 価格の範囲が、¥300~¥9,999,999の間であること
  # 出品を何度かしてチェック
  check_13

  # パスワードとパスワード（確認用）、値の一致が必須であること
  check_20


  # 自動チェック処理の終了のお知らせ
  finish_puts
end

# チェック前の準備
def start

  puts <<-EOT
----------------------------
自動チェックツールを起動します
まず初めに以下の3項目を入力してください

①動作チェックするアプリの本番環境URL
②basic認証[ユーザー名]
③basic認証[パスワード]

「①動作チェックするアプリの本番環境URL」を入力しenterキーを押してください (例：https://afternoon-bayou-26262.herokuapp.com/)
EOT

  input_url = gets.chomp
  # 「https://」を削除
  @url_ele = input_url.gsub(/https:\/\//,"")
  puts "次に「②basic認証[ユーザー名]」を入力しenterキーを押してください (例：admin)"
  @b_id= gets.chomp
  puts "次に「③basic認証[パスワード]」を入力しenterキーを押してください (例：2222)"
  @b_password = gets.chomp

  puts "自動チェックを開始します"

end

# ランダム情報で生成されるユーザー情報を出力する(再度ログインなどをする可能性もあるため)
def print_user_status
  @puts_num_array[0].push("【補足情報】ユーザーアカウント情報一覧(手動でのログイン時に使用)\n")
  @puts_num_array[0].push("パスワード: #{@password} (全ユーザー共通)\n")
  @puts_num_array[0].push("ユーザー名: lifecoach_test_user1\nemail: #{@email}\n\nユーザー名: lifecoach_test_user2\nemail: #{@email2}\n\nユーザー名: lifecoach_test_user3\nemail: #{@email3}\n\n")
end

# よく使う冗長なコードをメソッド化
# セレクトタグのインスタンス化をメソッド化
def select_new(element)
  return Selenium::WebDriver::Support::Select.new(element )
end

# なんで作ったか不明。現状使われていないはず
def two_class_displayed_check(first_ele, second_ele)
  f_flag = @d.find_element(:class,second_ele).displayed? rescue false
  s_flag = @d.find_element(:class,first_ele).displayed? rescue false
  if f_flag || s_flag then return true end
  return false
end

# 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまため
def re_sigin_up
    randm_word = SecureRandom.hex(5)
    @email = "user1_#{randm_word}@co.jp"
    @puts_num_array[0].push("\n【補足情報】ユーザー新規登録テストにて、ユーザー1の情報が更新されたため更新されたユーザー情報を出力します(手動でのログイン時に使用)")
    @puts_num_array[0].push("パスワード: #{@password}")
    @puts_num_array[0].push("ユーザー名: 未入力\nemail: #{@email}\n")
end

# ユーザーのログインメソッド
def login_any_user(email, pass)
  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  display_flag = @d.find_element(:class,"logout").displayed? rescue false
  # ログイン状態であればログアウトしておく
  if display_flag
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
  end

  @d.find_element(:class,"login").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  @d.find_element(:id, 'email').send_keys(email)
  @d.find_element(:id, 'password').send_keys(pass)
  @d.find_element(:class,"login-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
  # トップページ画面
  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

end

# 新規登録に必要な項目入力を行うメソッド
def input_sign_up_method(nickname, email, pass, first, last, first_kana, last_kana)
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').send_keys(nickname)
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').send_keys(email)
  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').send_keys(pass)
  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').send_keys(pass)
  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').send_keys(first)
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').send_keys(last)
  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').send_keys(first_kana)
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').send_keys(last_kana)

  # 生年月日入力inputタグの親クラス
  parent_birth_element = @d.find_element(:class, 'input-birth-wrap')
  # 3つの子クラスを取得
  birth_elements = parent_birth_element.find_elements(:tag_name, 'select')
  birth_elements.each{|ele|
    # 年・月・日のそれぞれに値を入力
    select_ele = select_new(ele)
    select_ele.select_by(:index, @select_index)
  }

end

# 登録項目を削除するメソッド
def input_sign_up_delete
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').clear
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').clear
  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').clear
  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').clear
  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').clear
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').clear
  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').clear
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').clear
end

# 新規登録に必要な入力項目を全てクリアにするメソッド
def clear_sign_up_method
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').clear
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').clear
  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').clear
  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').clear
  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').clear
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').clear
  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').clear
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').clear

  # 将来的には生年月日のセレクトもクリアにしたい
end

# 商品出品時の入力必須項目へ入力するメソッド
# あくまで項目の入力までを行う。入力後の出品ボタンは押さない
def input_item_new_method(name, info, price, image)

  # 以下、各項目の入力を行う
  # 商品画像
  @wait.until {@d.find_element(:id,"item-image").displayed?}
  @d.find_element(:id,"item-image").send_keys(image)

  # 商品名
  @wait.until {@d.find_element(:id,"item-name").displayed?}
  @d.find_element(:id,"item-name").send_keys(name)

  # 商品説明
  @wait.until {@d.find_element(:id,"item-info").displayed?}
  @d.find_element(:id,"item-info").send_keys(info)

  # カテゴリーはセレクトタグから値を選択
  @wait.until {@d.find_element(:id,"item-category").displayed?}
  item_category_element = @d.find_element(:id,"item-category")
  item_category = select_new(item_category_element)
  item_category.select_by(:value, @value)

  # 商品の状態はセレクトタグから値を選択
  @wait.until {@d.find_element(:id,"item-sales-status").displayed?}
  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = select_new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)

  # 送料の負担はセレクトタグから値を選択
  @wait.until {@d.find_element(:id,"item-shipping-fee-status").displayed?}
  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = select_new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)

  # 発送先はセレクトタグから値を選択
  @wait.until {@d.find_element(:id,"item-prefecture").displayed?}
  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = select_new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)

  # 発送までの日数
  @wait.until {@d.find_element(:id,"item-scheduled-delivery").displayed?}
  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = select_new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)


  # 価格
  @wait.until {@d.find_element(:id,"item-price").displayed?}
  @d.find_element(:id,"item-price").send_keys(price)
end

# 再出品するために必須項目を全クリア
# 再出品が前提のため、最初から出品画面にいる状態
def clear_item_new_method
  @wait.until {@d.find_element(:id,"item-image").displayed?}
  # 商品画像
  @d.find_element(:id,"item-image").clear
  # 商品名
  @d.find_element(:id,"item-name").clear
  # 商品説明
  @d.find_element(:id,"item-info").clear

  item_category_blank = @d.find_element(:id,"item-category")
  item_category_blank = select_new(item_category_blank)
  item_category_blank.select_by(:value, @blank)

  item_sales_status_blank = @d.find_element(:id,"item-sales-status")
  item_sales_status_blank = select_new(item_sales_status_blank )
  item_sales_status_blank.select_by(:value, @blank)

  item_shipping_fee_status_blank = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status_blank = select_new(item_shipping_fee_status_blank )
  item_shipping_fee_status_blank.select_by(:value, @blank)

  item_prefecture_blank = @d.find_element(:id,"item-prefecture")
  item_prefecture_blank = select_new(item_prefecture_blank )
  item_prefecture_blank.select_by(:value, @blank)

  item_scheduled_delivery_blank = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery_blank = select_new(item_scheduled_delivery_blank )
  item_scheduled_delivery_blank.select_by(:value, @blank)

  # 価格
  @d.find_element(:id,"item-price").clear
end

# トップ画面にて「出品」ボタンをクリックするメソッド
# 引数flagは遷移後にputs分の出力有無
# 出品ボタンは受講生によってリンクタグを付与している要素にバラ付きが見られるためこのメソッドがある
def click_purchase_btn(flag)

  # 出品ボタンを押して画面遷移できるかどうか
  if /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn").click
    if flag then @puts_num_array[0].push("【補足情報】出品ページに遷移 ※[class: purchase-btn]で遷移") end
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    if flag then @puts_num_array[0].push("【補足情報】出品ページに遷移 ※[class: purchase-btn-text]で遷移") end
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-icon").click
    if flag then @puts_num_array[0].push("【補足情報】出品ページに遷移 ※[class: purchase-btn-icon]で遷移") end
  else
    @puts_num_array[0].push("×：トップ画面から出品ページに遷移できない")
    raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
  end
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
end

# トップ画面にて商品名を基準に該当の商品をクリックして商品詳細画面へ遷移する
def item_name_click_from_top(name)
  # トップ画面の商品名要素を全部取得
  items = @d.find_elements(:class,"item-name")
  # 商品名で判別してクリック
  items.each{|item|
    if item.text == name
      item.click
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
      # 該当の商品名をクリックできた時点でループ処理を終了
      break
    end
  }
end

# 直前に出品した商品を削除して再度出品画面に戻る
# 各チェックメソッドなどでダミーデータを使った商品登録時に万が一商品を出品できてしまった場合などにリセット目的でのメソッド
def return_purchase_before_delete_item(item_name)

  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
  # トップ画面にて商品名を基準に該当の商品をクリックして商品詳細画面へ遷移する
  item_name_click_from_top(item_name)
  # 商品削除ボタンをクリック
  @d.find_element(:class,"item-destroy").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
  # 削除完了画面があるかもしれないのでトップに戻る
  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
  # 出品画面へ
  click_purchase_btn(false)
end

# 購入情報の入力(入力のみ、決済ボタンクリックまではしない)
# 前提：購入画面に遷移していること
# 引数：カード情報のみ引数化(複数枚のカード情報でのテストを行う可能性を加味)、住所情報は毎回固定
def input_purchase_information(card_number, card_exp_month, card_exp_year, card_cvc)
  # カード番号を入力した状態で再度決済を行う
  @wait.until {@d.find_element(:id, 'card-number').displayed?}
  @d.find_element(:id, 'card-number').send_keys(card_number)
  @wait.until {@d.find_element(:id, 'card-exp-month').displayed?}
  @d.find_element(:id, 'card-exp-month').send_keys(card_exp_month)
  @wait.until {@d.find_element(:id, 'card-exp-year').displayed?}
  @d.find_element(:id, 'card-exp-year').send_keys(card_exp_year)
  @wait.until {@d.find_element(:id, 'card-cvc').displayed?}
  @d.find_element(:id, 'card-cvc').send_keys(card_cvc)
  @wait.until {@d.find_element(:id, 'postal-code').displayed?}
  @d.find_element(:id, 'postal-code').send_keys(@postal_code)

  @wait.until {@d.find_element(:id, 'prefecture').displayed?}
  @d.find_element(:id, 'prefecture').send_keys(@prefecture)

  @wait.until {@d.find_element(:id, 'city').displayed?}
  @d.find_element(:id, 'city').send_keys(@city)

  @wait.until {@d.find_element(:id, 'addresses').displayed?}
  @d.find_element(:id, 'addresses').send_keys(@addresses)

  @wait.until {@d.find_element(:id, 'phone-number').displayed?}
  @d.find_element(:id, 'phone-number').send_keys(@phone_number)

end


# チェック文章を出力配列へ格納するメソッド
# 引数①セクション番号、②連番、③出力文章、④複数boolean
def add_puts_num(section_num, number, str, bool)
  puts_detail = {"section"=> section_num , "num"=> number , "puts_string"=> str , "array_bool"=> bool}
  @puts_num_array.push(puts_detail)
end



# 新規登録
# ニックネームは未入力
def sign_up_nickname_input

  display_flag = @d.find_element(:class,"logout").displayed? rescue false
  # ログイン状態であればログアウトして登録ページに遷移する。
  if display_flag
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.find_element(:class,"sign-up").click
  end

  @d.find_element(:class,"sign-up").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
  # ユーザー新規登録画面でのエラーハンドリングログを取得
  check_19_1
  # 新規登録に必要な項目入力を行うメソッド
  input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').clear

  @d.find_element(:class,"register-red-btn").click
end

# パスワードは、6文字以上での入力が必須であること(6文字が入力されていれば、登録が可能なこと）
def sign_up_password_short
  display_flag = @d.find_element(:class,"logout").displayed? rescue false
  # ログイン状態であればログアウトしておく
  if display_flag
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.find_element(:class,"sign-up").click
  else
    input_sign_up_delete
  end
  # 新規登録に必要な項目入力を行うメソッド。パスワード文字数4文字
  input_sign_up_method(@nickname, @email, @password_short, @first_name, @last_name, @first_name_kana, @last_name_kana)
  @d.find_element(:class,"register-red-btn").click
  # if文でチェック
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[1][17] = "[1-017] ×：パスワードは、5文字以下でも登録できる"
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.find_element(:class,"sign-up").click
    #raise "ユーザー登録バリデーションにて不備あり"
  else
    @puts_num_array[1][17] = "[1-017] ◯"  #：パスワードは、6文字以上での入力が必須であること(6文字が入力されていれば、登録が可能なこと
    # パスワードの上書きでも登録が成功しない場合は処理を終了
  end
    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:class,"logout").displayed? rescue false
    if display_flag
      @d.find_element(:class,"logout").click
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
      @d.get(@url)
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    end
    # 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまため
    re_sigin_up
end

# パスワードは、半角英数字混合での入力が必須であること
# 文字のみでの入力
def sign_up_password_string
  jard
  display_flag = @d.find_element(:class,"logout").displayed? rescue false
  # ログイン状態であればログアウトしておく
  if display_flag
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.find_element(:class,"sign-up").click
  else
    input_sign_up_delete
  end
  # 新規登録に必要な項目入力を行うメソッド。文字のみでの入力
  input_sign_up_method(@nickname, @email, @password_string, @first_name, @last_name, @first_name_kana, @last_name_kana)
  @d.find_element(:class,"register-red-btn").click
  # if文でチェック
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[1][18] = "[1-018] ×：パスワードは、文字のみでも登録できる"
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.find_element(:class,"sign-up").click
    #raise "ユーザー登録バリデーションにて不備あり"
  else
    @puts_num_array[1][18] = "[1-018] ◯"  #：パスワードは、半角英数字混合での入力が必須であること
    # パスワードの上書きでも登録が成功しない場合は処理を終了
  end
    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:class,"logout").displayed? rescue false
    if display_flag
      @d.find_element(:class,"logout").click
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
      @d.get(@url)
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    end
    # 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまため
    re_sigin_up
end

# まだ登録が完了していない場合、再度登録
def sign_up_retry
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /会員情報入力/ .match(@d.page_source)
    @puts_num_array[1][1] = "[1-001] ◯"  #：必須項目が一つでも欠けている場合は、ユーザー登録ができない"
  elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[1][2] = "[1-002] ×：ニックネーム未入力でも登録できてしまう。またはトップページに遷移してしまう"  #：ニックネームが必須であること"
    @puts_num_array[1][1] = "[1-001] ×：必須項目が一つでも欠けている状態でも登録できてしまう。"  #：必須項目が一つでも欠けている場合は、ユーザー登録ができない"

    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:class,"logout").displayed? rescue false
    if display_flag
      @d.find_element(:class,"logout").click
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
      @d.get(@url)
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    end
    @d.find_element(:class,"sign-up").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    # 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまため
    re_sigin_up
  end


  # 再度登録
  # まず入力の準備として項目情報をクリア
  clear_sign_up_method

  # 今度はニックネーム含めた全項目に情報を入力していく
  input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)

  @d.find_element(:class,"register-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[1][2]  = "[1-002] ◯"  #：ニックネームが必須であること"
    @puts_num_array[1][3]  = "[1-003] ◯"  #：メールアドレスが必須である"
    @puts_num_array[1][4]  = "[1-004] ◯"  #：メールアドレスは一意性である"      #これはまだ立証できない
    @puts_num_array[1][5]  = "[1-005] ◯"  #：メールアドレスは@を含む必要がある"  #これはまだ立証できない
    @puts_num_array[1][6]  = "[1-006] ◯"  #：パスワードが必須である"
    # puts "[1-] ◯：パスワードは6文字以上である"  #これはまだ立証できない
    # puts "[1-] ◯：パスワードは半角英数字混合である"  #これはまだ立証できない
    @puts_num_array[1][7]  = "[1-007] ◯"  #：パスワードは確認用を含めて2回入力する"  #これはまだ立証できない
    @puts_num_array[1][8]  = "[1-008] ◯"  #：ユーザー本名が、名字と名前がそれぞれ必須である"  #これはまだ立証できない
    @puts_num_array[1][9]  = "[1-009] ◯"  #：ユーザー本名は全角（漢字・ひらがな・カタカナ）で入力させる"  #これはまだ立証できない
    @puts_num_array[1][10] = "[1-010] ◯"  #：ユーザー本名のフリガナが、名字と名前でそれぞれ必須である"
    @puts_num_array[1][11] = "[1-011] ◯"  #：ユーザー本名のフリガナは全角（カタカナ）で入力させる"
    @puts_num_array[1][12] = "[1-012] ◯"  #：生年月日が必須である"  #これはまだ立証できない
    @puts_num_array[1][13] = "[1-013] ◯"  #：必須項目を入力し、ユーザー登録ができる"

  # 登録に失敗した場合はパスワードを疑う
  elsif /会員情報入力/ .match(@d.page_source)
    @puts_num_array[0].push("×：ユーザー新規登録時にパスワードに大文字が入っていないと登録できない可能性あり、パスワード文字列に大文字(aaa111 → Aaa111)を追加して再登録トライ")

    # パスワードの内容でエラーになった可能性あるため、大文字含めた文字列に変更
    @password = "Aaa111"
    clear_sign_up_method
    input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)
    @d.find_element(:class,"register-red-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
      @puts_num_array[1][2] = "[1-002] ◯"  #：ニックネームが必須であること"
      @puts_num_array[1][3] = "[1-003] ◯"  #：メールアドレスが必須である"
      @puts_num_array[1][4] = "[1-004] ◯"  #：メールアドレスは一意性である"  #これはまだ立証できない
      @puts_num_array[1][5] = "[1-005] ◯"  #：メールアドレスは@を含む必要がある"  #これはまだ立証できない
      @puts_num_array[1][6] = "[1-006] ◯"  #：パスワードが必須である"
      # puts "[1-] ◯：パスワードは6文字以上である"  #これはまだ立証できない
      # puts "[1-] ◯：パスワードは半角英数字混合である"  #これはまだ立証できない
      @puts_num_array[1][7] = "[1-007] ◯"  #：パスワードは確認用を含めて2回入力する"  #これはまだ立証できない
      @puts_num_array[0].push("【補足情報】◯：ユーザー新規登録時にパスワードに大文字を入れたことで登録が成功 (パスワードをaaa111 → Aaa111に変更して登録完了)")
      @puts_num_array[1][8] = "[1-008] ◯"  #：ユーザー本名が、名字と名前がそれぞれ必須である"  #これはまだ立証できない
      @puts_num_array[1][9] = "[1-009] ◯"  #：ユーザー本名は全角（漢字・ひらがな・カタカナ）で入力させる"  #これはまだ立証できない
      @puts_num_array[1][10] = "[1-010] ◯"  #：ユーザー本名のフリガナが、名字と名前でそれぞれ必須である"
      @puts_num_array[1][11] = "[1-011] ◯"  #：ユーザー本名のフリガナは全角（カタカナ）で入力させる"
      @puts_num_array[1][12] = "[1-012] ◯"  #：生年月日が必須である"  #これはまだ立証できない
      @puts_num_array[1][13] = "[1-013] ◯"  #：必須項目を入力し、ユーザー登録ができる"

      # パスワードの上書きでも登録が成功しない場合は処理を終了
    else
      @puts_num_array[1][13] = "[1-013] ×：必須項目を入力してもユーザー登録ができない"
      @puts_num_array[0].push("ユーザー登録バリデーションが複雑なためユーザー登録ができません。ユーザー登録できない場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します")
      @puts_num_array[0].push("手動でのアプリチェックを行ってください")
      raise "ユーザー登録バリデーションにて不備あり"
    end
  end
end


# トップメニューに戻ってきた後にログアウトする
def logout_from_the_topMenu

  @d.find_element(:class,"logout").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

end

# ログイン
def login_user1
  @wait.until {@d.find_element(:class,"login").displayed?}
  @d.find_element(:class,"login").click
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').send_keys(@email)
  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').send_keys(@password)
  @wait.until {@d.find_element(:class,"login-red-btn").displayed?}
  @d.find_element(:class,"login-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  @puts_num_array[1][15] = "[1-015] ◯"  #：ヘッダーの新規登録/ログインボタンをクリックすることで、各ページに遷移できること
  @puts_num_array[1][16] = "[1-016] ◯"  #：ヘッダーのログアウトボタンをクリックすることで、ログアウトができること
  # トップ画面に戻れているか
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[1][14] = "[1-014] ◯"  #：ログイン/ログアウトができる"
  else
    @puts_num_array[1][14] = "[1-014] ×：ログイン/ログアウトができない、もしくはログイン後にトップページへ遷移しない"
    @d.get(@url)
  end
end

# 出品
# 価格未入力
def item_new_price_uninput

  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  # トップ画面で出品ボタンをクリック
  click_purchase_btn(true)

  # 商品出品画面でのエラーハンドリングログを取得
  check_19_2

  # 商品出品時の必須項目へ入力するメソッド
  input_item_new_method(@item_name, @item_info, @item_price, @item_image)

  sleep 1
  # 入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)
  check_17

  # 商品価格のみ空白
  @d.find_element(:id,"item-price").clear

  # 「出品する」ボタンをクリック
  @d.find_element(:class,"sell-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /商品の情報を入力/.match(@d.page_source)
    @puts_num_array[2][12] = "[2-012] ◯"  #：入力に問題がある状態で出品ボタンが押されたら、出品ページに戻りエラーメッセージが表示されること"
    @puts_num_array[2][3] = "[2-003] ◯"  #：必須項目が一つでも欠けている場合は、出品ができない"
    @puts_num_array[2][14] = "[2-014] ◯" #:ログイン状態のユーザーだけが、商品出品ページへ遷移できること
  elsif /FURIMAが選ばれる3つの理由/.match(@d.page_source)
    @puts_num_array[2][12] = "[2-012] ×：価格の入力なしで商品出品を行うと、商品出品ページにリダイレクトされずトップページへ遷移してしまう"
    @puts_num_array[2][3] = "[2-003] ×：価格の入力なしで商品出品を行うと、出品できてしまう"
  else
    @puts_num_array[2][12] = "[2-012] ×：価格の入力なしで商品出品を行うと、商品出品ページにリダイレクトされない"
  end
end

# 必須項目を全て入力した上で出品
# エラーハンドリングのチェック
def item_new_require_input

  clear_item_new_method

  input_item_new_method(@item_name, @item_info, @item_price, @item_image)

  # 商品情報のセレクトタグにて選択した情報を変数に代入
  @item_category_word            = select_new(@d.find_element(:id,"item-category")).selected_options[0].text
  @item_status_word              = select_new(@d.find_element(:id,"item-sales-status")).selected_options[0].text
  @item_shipping_fee_status_word = select_new(@d.find_element(:id,"item-shipping-fee-status")).selected_options[0].text
  @item_prefecture_word          = select_new(@d.find_element(:id,"item-prefecture")).selected_options[0].text
  @item_scheduled_delivery_word  = select_new(@d.find_element(:id,"item-scheduled-delivery")).selected_options[0].text

  @d.find_element(:class,"sell-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[2][2] = "[2-002] ◯"  #：商品画像を1枚つけることが必須であること(ActiveStorageを使用すること)"
    @puts_num_array[2][4] = "[2-004] ◯"  #：必須項目を入力した上で出品ができること"
    @puts_num_array[2][5] = "[2-005] ◯"  #：商品の説明が必須である"
    @puts_num_array[2][6] = "[2-006] ◯"  #：カテゴリーの情報が必須である"
    @puts_num_array[2][7] = "[2-007] ◯"  #：商品の状態についての情報が必須である"
    @puts_num_array[2][8] = "[2-008] ◯"  #：配送料の負担についての情報が必須である"
    @puts_num_array[2][9] = "[2-009] ◯"  #：発送元の地域についての情報が必須である"
    @puts_num_array[2][10] = "[2-010] ◯"  #：発送までの日数についての情報が必須である"
    @puts_num_array[2][11] = "[2-011] ◯"  #：販売価格についての情報が必須である"
    @puts_num_array[2][13] = "[2-013] △：販売価格を半角数字で保存可能。全角数字での出品可否は手動確認"  #：販売価格は半角数字のみ保存可能であること"
  end
end

# ログイン状態
# トップページ　→　商品詳細画面(自分で出品した商品)
# 商品編集(エラーハンドリング)
def item_edit
  # トップ画面にて商品名を基準に該当の商品をクリックして商品詳細画面へ遷移する
  item_name_click_from_top(@item_name)

  # 商品詳細画面
  if /編集/.match(@d.page_source)
    @puts_num_array[4][1] = "[4-001]1/4 ◯：出品者でログイン中、編集ボタン表示あり"  #ログイン状態の出品者のみ、「編集・削除ボタン」が表示されること"
    @flag_4_001 += 1
  else
    @puts_num_array[4][1] = "[4-001] ×：出品者でログイン中、編集ボタン表示なし"
  end

  if /削除/.match(@d.page_source)
    # 出力文が複数の場合は文字列にい連結する形をとる
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001]2/4 ◯：出品者でログイン中、削除ボタン表示あり"  #ログイン状態の出品者のみ、「編集・削除ボタン」が表示されること"
  else
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001] ×：出品者でログイン中、削除ボタン表示なし"
  end

  # 商品詳細ページで商品出品時に登録した情報が見られるようになっている
  check_18

  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  # 商品編集ボタンクリック
  @d.find_element(:class,"item-red-btn").click

  # 商品出品時とほぼ同じ見た目で商品情報編集機能が実装されていること
  check_7

  # ログアウト状態のユーザーは、URLを直接入力して商品情報編集ページへ遷移しようとすると、ログインページに遷移すること(別ウィンドウ操作処理)
  check_8

  # 別ウィンドウにて異なるユーザーでログインした際はウィンドウを元に戻す時は再度ログインし直す
  @d.get(@url)
  # 元のuser1でログイン
  login_any_user(@email, @password)

  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  # 商品編集ボタンクリック
  @d.find_element(:class,"item-red-btn").click

  # 「商品の説明」項目に正常な情報を入力して編集してみる
  @wait.until {@d.find_element(:id,"item-info").displayed?}
  @puts_num_array[5][5] = "[5-005] ◯" #ログイン状態の出品者のみ、出品した商品の商品情報編集ページに遷移できること
  @d.find_element(:id,"item-info").send_keys(@item_info_re)
  @d.find_element(:class,"sell-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}


  # 稀に編集画面に遷移した際に値を保持していない実装をしている受講生がいるため、商品詳細画面に遷移できているかあぶり出すチェック項目
  if /#{@item_info_re}/.match(@d.page_source)
    @puts_num_array[5][2] = "[5-002] ◯"  #：必要な情報を適切に入力すると、商品情報（商品画像・商品名・商品の状態など）を変更できること"
  elsif /#{@item_info}/.match(@d.page_source)
    @puts_num_array[5][2] = "[5-002] ×：商品編集画面にて「商品説明」を編集し確定させたが、編集前の情報が表示されている"
  elsif /FURIMAが選ばれる3つの理由/.match(@d.page_source)
    @puts_num_array[5][2] = "[5-002] △：商品編集画面にて「商品説明」を編集し確定させるとトップページへ遷移してしまう設計のため、「商品説明」項目を確認できず。手動確認"
    # 必要な情報が入力された状態で編集確定されると商品詳細画面に戻ってくるため、detail-itemが表示されるが正解
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
  end

end

# ログアウトしてから商品の編集や購入ができるかチェック
def logout_item_edit_and_buy
  # ヘッダーのトップへ遷移するアイコンをクリック
  @d.find_element(:class,"furima-icon").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # ログアウトをクリック
  @d.find_element(:class,"logout").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # ログアウト後のトップページで「出品する」ボタンをクリック
  click_purchase_btn(false)

  # ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること
  check_9


  # トップページにて出品された商品一覧(商品画像)が表示されているかどうか
  @wait.until {@d.find_element(:class, "item-img-content").displayed?}
  if /#{@item_image_name}/ .match(@d.page_source)
    @puts_num_array[3][2] = "[3-002] ◯"  #：ログアウト状態のユーザーでも、商品一覧表示ページを見ることができること"
  else
    @puts_num_array[3][2] = "[3-002] ×：ログアウト状態だとトップ画面にて出品画像が表示されない"
  end

  # 商品詳細画面へ遷移
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 商品詳細ページでログアウト状態のユーザーには、「編集・削除・購入画面に進むボタン」が表示されないこと
  check_11

end

# 別名義のユーザーで登録 & ログイン
def login_user2

  @wait.until {@d.find_element(:class,"sign-up").displayed?}
  @d.manage.delete_all_cookies
  @d.find_element(:class,"sign-up").click
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').send_keys(@nickname2)
  @d.find_element(:id, 'email').send_keys(@email2)
  @d.find_element(:id, 'password').send_keys(@password)
  @d.find_element(:id, 'password-confirmation').send_keys(@password)
  @d.find_element(:id, 'first-name').send_keys(@first_name2)
  @d.find_element(:id, 'last-name').send_keys(@last_name2)
  @d.find_element(:id, 'first-name-kana').send_keys(@first_name_kana2)
  @d.find_element(:id, 'last-name-kana').send_keys(@last_name_kana2)
  
  # 生年月日入力inputタグの親クラス
  parent_birth_element = @d.find_element(:class, 'input-birth-wrap')
  # 3つの子クラスを取得
  birth_elements = parent_birth_element.find_elements(:tag_name, 'select')
  birth_elements.each{|ele|
    # 年・月・日のそれぞれに値を入力
    select_ele = select_new(ele)
    select_ele.select_by(:index, @select_index)
  }
  
  @d.find_element(:class,"register-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # ログイン状態の出品者以外のユーザーは、URLを直接入力して出品していない商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること
  check_15
  # ログイン状態の出品者以外のユーザーのみ、「購入画面に進むボタン」が表示されること
  check_12
  # 商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること
  check_3
end

def login_user2_item_buy
  @wait.until {@d.find_element(:class,"item-img-content").displayed?}

  # 自分が出品していない商品の詳細画面へ遷移
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}


  if /編集/ .match(@d.page_source)
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001]  ×：出品者以外でログイン中、編集ボタン表示あり"  #ログイン状態の出品者のみ、「編集・削除ボタン」が表示されること"
  else
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001]3/4 ◯：出品者以外でログイン中、編集ボタン表示なし"
    @flag_4_001 += 1
  end


  if /削除/ .match(@d.page_source)
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001]  ×：出品者以外でログイン中、削除ボタン表示あり"
  else
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001]4/4 ◯：出品者以外でログイン中、削除ボタン表示なし"
  end

  # [4-001]が立証されると合わせて[5-004]も立証可能
  if @flag_4_001 == 2
    @puts_num_array[5][4] = "[5-004] ◯"  #：ログイン状態の出品者のみ、出品した商品の商品情報を編集できること"
  else
    @puts_num_array[5][4] = "[5-004] ×：[4-001]チェックにて×が発生しているため"  #：出品者だけが編集ページに遷移できる"
  end

  #「購入画面に進む」ボタン
  @wait.until {@d.find_element(:class, "item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  @order_url_coat = @d.current_url
  @puts_num_array[0].push("売却済みのコート(user1出品)購入画面のURL→  " + @order_url_coat)

  # 商品購入画面でのエラーハンドリングログを取得
  check_19_3
  # 新規登録、商品出品、商品購入の際にエラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）
  check_19
  # コート購入前にチェック
  # ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページに遷移すること
  check_5
  # ログアウト状態のユーザーは、URLを直接入力して商品購入ページに遷移しようとすると、商品の販売状況に関わらずログインページに遷移すること
  check_22

  # check_22メソッドの中でログアウトしているためuser2でログイン
  login_any_user(@email2, @password)
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class, "item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click

  #クレジットカード情報入力画面に遷移
  # 購入情報の入力(入力のみ、決済ボタンクリックまではしない)
  input_purchase_information(@card_number, @card_exp_month, @card_exp_year, @card_cvc)

  # カード番号の項目のみ削除
  @d.find_element(:id, 'card-number').clear

  #カード番号情報のみ未入力状態で購入ボタンをおす
  @d.find_element(:class,"buy-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # バリデーションによるエラーメッセージ出力有無を確認
  display_flag = @d.find_element(:class,"error-alert").displayed? rescue false

  # カード情報入力画面にリダイレクトかつエラーメッセージが出力されている場合
  if /クレジットカード情報入力/ .match(@d.page_source) && display_flag
    @puts_num_array[7][7] = "[7-007] ◯"  #入力に問題がある状態で購入ボタンが押されたら、購入ページに戻りエラーメッセージが表示されること"


  # カード情報入力画面にリダイレクトのみ
  elsif /クレジットカード情報入力/ .match(@d.page_source)
    @puts_num_array[7][7] = "[7-007] ×：カード番号が入力されていない状態だと購入情報入力画面にリダイレクトはされるが、エラーメッセージは画面に出力されない"

    # カード番号未入力で商品購入ができてしまったら = トップページに戻ってきたら
  elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[7][7] = "[7-007] ×：カード番号が入力されていない状態でも、決済できる"
    @puts_num_array[0].push("不適切なクレジットカード決済方法で購入が完了したため自動チェックを中断します")
    raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
  else
    @puts_num_array[7][7] = "[7-007] ×"
    @puts_num_array[0].push("不適切なクレジットカード決済方法で購入が完了したため自動チェックを中断します")
    raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
  end


  # puts "◯クレジットカード情報は必須であり、正しいクレジットカードの情報で無いときは決済できない"  #正常な値での登録チェックを行っていないため未実証


  # カード番号を入力した状態で再度決済を行う
  input_purchase_information(@card_number, @card_exp_month, @card_exp_year, @card_cvc)


  #正常に決済する
  @d.find_element(:class,"buy-red-btn").click


  @wait.until {@d.find_element(:class,"furima-icon").displayed?}

  #：購入が完了したら、トップページまたは購入完了ページに遷移する"
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source) then @puts_num_array[7][6] = "[7-006] ◯" end

  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  @puts_num_array[7][2] = "[7-002] ◯"  #クレジットカードの情報は購入の都度入力させること"  #これは立証できていない
  @puts_num_array[7][3] = "[7-003] ◯"  #配送先の住所情報も購入の都度入力させること"
  @puts_num_array[7][4] = "[7-004] ◯"  #クレジットカード決済ができる"
  @puts_num_array[7][8] = "[7-008] ◯"  #必要な情報を適切に入力すると、商品の購入ができること

  # puts "◯配送先の情報として、郵便番号・都道府県・市区町村・番地・電話番号が必須であること"  #これは立証できていない
  # puts "◯郵便番号にはハイフンが必要であること（123-4567となる）"  #これは立証できていない
  # puts "◯電話番号にはハイフンは不要で、11桁以内である"  #これは立証できていない

end

# 購入後の商品状態や表示方法をチェック
def login_user2_after_purchase_check1

  login_any_user(@email2, @password)

  display_flag = @d.find_element(:class,"sold-out").displayed? rescue false
  # トップページでの表記をチェック
  if /Sold Out/ .match(@d.page_source) || display_flag
    @puts_num_array[3][1] = "[3-001] ◯"  #売却済みの商品は、「sould out」の文字が表示されるようになっている"
  else
    # sold outの表示処理は受講生によって様々のため目視で最終確認
    @puts_num_array[3][1] = "[3-001] △：売却済みの商品は、「sould out」の文字が表示されない。画像処理している可能性あるため要目視確認"
  end

  @wait.until {@d.find_element(:class,"item-img-content").displayed?}
  # 一度購入した商品の商品詳細画面へすすむ
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /購入画面に進む/ .match(@d.page_source)
    @puts_num_array[7][9] = "[7-009] △：一度購入した商品の商品詳細ページに再度購入ボタンが表示されている"
    @d.find_element(:class,"item-red-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    # 遷移先の画面がトップページに遷移したかで判断
    if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
      @puts_num_array[7][9] = "[7-009] ◯ ← △：しかし、購入ボタンを押してもトップページに遷移するので購入した商品は、再度購入できない状態になっているためOK"
    else
      @puts_num_array[7][9] = "[7-009] × ← △：また「購入ボタン」を押すとトップページ以外の画面に遷移する状態になっている"
      @d.get(@url)
    end
    # 84期まではログアウトユーザーが詳細画面を見ても「購入画面に進む」ボタンが表示されていてもOK(クリックするとトップに戻ること)
    # 85期からは「購入画面に進む」ボタンの表示自体がNG

  else
    @puts_num_array[7][9] = "[7-009] ◯"  #：ログイン状態の出品者以外のユーザーのみ、「購入画面に進む」ボタンが表示されること"
    @d.get(@url)
  end

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 出品画面へ遷移
  click_purchase_btn(false)
end

# user2によるサングラス出品
def login_user2_item_new
  # 商品出品時の入力必須項目へ入力するメソッド
  input_item_new_method(@item_name2, @item_info2, @item_price2, @item_image2)
  @d.find_element(:class,"sell-btn").click
end

# 現在使用停止中
# user1でログインし、サングラスの購入URLを取得する
def login_user1_item_show
  # 出品完了後、トップページからログアウト→user1にてログイン
  login_any_user(@email, @password)

  # サングラスの詳細画面へ
  item_name_click_from_top(@item_name2)

  # 購入画面へ
  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 購入確定前のURL取得
  @order_url_glasses = @d.current_url
  @puts_num_array[0].push("サングラス購入画面の@URL→  "+ @order_url_glasses)

  # # 購入情報の入力(入力のみ、決済ボタンクリックまではしない)
  # input_purchase_information(@card_number, @card_exp_month, @card_exp_year, @card_cvc)

  # # 商品購入
  # @d.find_element(:class,"buy-red-btn").click
  # @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

end

# ログアウト状態で商品購入
def no_user_item_buy_check

  # トップページに遷移
  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  display_flag = @d.find_element(:class,"logout").displayed? rescue false
  # ログイン状態であればログアウトしておく
  if display_flag
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
  end

  # ログアウト状態でサングラスの商品詳細画面へ遷移
  item_name_click_from_top(@item_name2)
  # 商品詳細画面のシンボルである「不適切な商品の通報」ボタンの有無で判断
  if /不適切な商品の通報/ .match(@d.page_source)
    @puts_num_array[4][2] = "[4-002] ◯"  #：ログアウト状態のユーザーでも、商品詳細表示ページを閲覧できること"
  else
    @puts_num_array[4][2] = "[4-002] ×：ログアウト状態では商品詳細表示ページに遷移できない"
  end

  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

end

# user2(サングラスの出品者)によるサングラスの画面遷移チェック
def login_user2_after_purchase_check2
  #user2(サングラスの出品者)でログイン
  login_any_user(@email2, @password)

  # サングラスの詳細画面へ
  item_name_click_from_top(@item_name2)

  # 商品削除ボタンをクリック
  @wait.until {@d.find_element(:class,"item-destroy").displayed?}
  @d.find_element(:class,"item-destroy").click
  # 削除完了画面等があっても処理が止まらないように一度トップページへ遷移しておく
  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 最新出品商品名 = 「サングラス」以外の商品名(サングラスを削除したため)
  # トップページに表示されている一番最初の商品名を取得
  latest_item_name = @d.find_element(:class,"item-name").text
  if latest_item_name == @item_name2
    @puts_num_array[6][1] = "[6-001] ×：ログイン状態の出品者が出品した商品情報を削除できない(商品一覧画面から削除できていない)"
  else
    @puts_num_array[6][1] = "[6-001] ◯"  #：出品者だけが商品情報を削除できる"
  end
end


# LCが自動チェックツール実行後に手動で確認しやすいように商品を出品し、商品編集URLと商品購入URLを取得しておく
# user2による出品(サングラス)→user1でログインして購入画面URLの取得
def login_user2_item_new_2nd
  # 出品画面へ遷移
  click_purchase_btn(false)

  # 商品出品時の入力必須項目へ入力するメソッド
  input_item_new_method(@item_name2, @item_info2, @item_price2, @item_image2)
  @d.find_element(:class,"sell-btn").click

  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # サングラスの詳細画面へ
  item_name_click_from_top(@item_name2)

  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  # 商品編集ボタンクリック
  @d.find_element(:class,"item-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 編集画面のURL取得
  @edit_url_glasses = @d.current_url
  @puts_num_array[0].push("購入前のサングラス(user2出品)編集画面のURL→  "+ @edit_url_glasses)

  # user1でログイン
  login_any_user(@email, @password)
  # サングラス詳細画面へ
  item_name_click_from_top(@item_name2)

  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  # 購入ボタンクリック
  @d.find_element(:class,"item-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 購入画面のURL取得
  @order_url_glasses = @d.current_url
  @puts_num_array[0].push("購入前のサングラス(user2出品)購入画面のURL→  "+ @order_url_glasses)

end

# 自動チェック処理の終了のお知らせ
def finish_puts
  @puts_num_array[0].push("自動チェックツール全プログラム終了")
  @puts_num_array[0].push("\n\n自動チェック途中にuserアカウント情報の変更を行う場合があるため、手動チェック時は以下の最終確定アカウント情報をお使いください")
  @puts_num_array[0].push("パスワード: #{@password} (全ユーザー共通)\n")
  @puts_num_array[0].push("ユーザー名: lifecoach_test_user1\nemail: #{@email}\n\nユーザー名: lifecoach_test_user2\nemail: #{@email2}\n\nユーザー名: lifecoach_test_user3\nemail: #{@email3}\n\n")
end