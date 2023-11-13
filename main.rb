# チェック項目のメソッドをまとめているファイル
require './check_list'
Dir[File.dirname(__FILE__) + '/check_lists/*.rb'].each {|file| require file }
# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
# require 'ruby_jard'

# メモ
# 購入時に起こっていたエラー詳細
# item-red-btn = 商品詳細画面での商品の編集 or 購入のボタン
# buy-red-btn  = 購入画面での購入ボタン


def main

  start

  # basic認証が実装されている
  basic_check

  # トップページに移動（例："http://#{b_id}:#{b_password}@localhost:3000/")
  @d.get(@url)

  #商品が出品されていない状態では、ダミーの商品情報が表示されること
  check_dummy_item
  # ランダム情報で生成されるユーザー情報を出力する(再度ログインなどをする可能性もあるため)
  print_user_status

  # ユーザー
  user_check

  # # 出品
  new_check

  # # 自分で出品した商品の商品編集(エラーハンドリング)
  # item_edit

  # # ログアウトしてから商品の編集や購入ができるかチェック
  # logout_item_edit_and_buy

  # # ユーザー状態：user2
  # # 出品：コート = user1,サングラス = なし
  # # 購入：コート = user2,サングラス = なし

  # # user2で登録 & ログイン
  # login_user2
  # # user2が商品購入
  # login_user2_item_buy

  # # 出品者・出品者以外にかかわらず、ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること
  # check_16

  # # ログイン状態の出品者以外のユーザーが、URLを直接入力して売却済み商品の商品購入ページへ遷移しようとすると、トップページに遷移すること
  # check_6

  # # 出品者でも、売却済みの商品に対しては「編集・削除ボタン」が表示されないこと
  # check_10

  # # ログアウト状態のユーザーは、URLを直接入力して売却済みの商品情報編集ページへ遷移しようとすると、ログインページに遷移すること
  # # check_21


  # # 購入後の商品状態や表示方法をチェック
  # login_user2_after_purchase_check1


  # # ユーザー状態：user2
  # # 出品：コート = user1,サングラス = user2
  # # 購入：コート = user2,サングラス = なし

  # # user2による出品(サングラス)
  # login_user2_item_new

  # # ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること
  # # サングラス　→　コートの順に出品されているかチェック
  # # check_4メソッド内でuser2 → ログアウト状態に移行
  # check_4

  # # ユーザー状態：ログアウト → user1
  # # 出品：コート = user1,サングラス = user2
  # # 購入：コート = user2,サングラス = user1

  # # login_user1_item_showメソッドは実行の必要がなくなったためコメントアウト
  # # ログアウト → user1でログイン
  # # サングラスの購入URL情報を取得
  # # login_user1_item_show

  # # ユーザー状態：user1 → ログアウト
  # # 出品：コート = user1,サングラス = user2
  # # 購入：コート = user2,サングラス = user1

  # # ログアウトしたユーザーで購入できるかチェック
  # no_user_item_buy_check

  # # user2(サングラスの出品者)によるサングラスの画面遷移チェック
  # login_user2_after_purchase_check2

  # # LCが自動チェックツール実行後に手動で確認しやすいように商品を出品し、商品編集URLと商品購入URLを取得しておく
  # # user2による出品(サングラス)→user1でログインして購入画面URLの取得
  # login_user2_item_new_2nd

  # # 価格の範囲が、¥300~¥9,999,999の間であること
  # # 出品を何度かしてチェック
  # check_13

  # # パスワードとパスワード（確認用）、値の一致が必須であること
  # check_20


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

  「①動作チェックするアプリの本番環境URL」を入力しenterキーを押してください (例：https://furima2020.herokuapp.com/)
  EOT

  input_url = gets.chomp
  # 「https://」を削除
  if input_url.include?("https")
    @url_ele = input_url.gsub(/https:\/\//,"")
  elsif input_url.include?("http")
    @url_ele = input_url.gsub(/http:\/\//,"")
  end
  puts "次に「②basic認証[ユーザー名]」を入力しenterキーを押してください (例：admin)"
  @b_id = gets.chomp
  puts "次に「③basic認証[パスワード]」を入力しenterキーを押してください (例：2222)"
  @b_password = gets.chomp

  @url ="http://#{@b_id}:#{@b_password}@" + @url_ele
  puts "自動チェックを開始します"

end

# ランダム情報で生成されるユーザー情報を出力する(再度ログインなどをする可能性もあるため)
def print_user_status
  @puts_num_array[0].push("【補足情報】ユーザーアカウント情報一覧(手動でのログイン時に使用)\n")
  @puts_num_array[0].push("パスワード: #{@users[0][:password]} (全ユーザー共通)\n")
  @puts_num_array[0].push("ユーザー名: lifecoach_test_user1\nemail: #{@users[0][:email]}\n\nユーザー名: lifecoach_test_user2\nemail: #{@users[1][:email]}\n\nユーザー名: lifecoach_test_user3\nemail: #{@users[2][:email]}\n\n")
end

# よく使う冗長なコードをメソッド化
# セレクトタグのインスタンス化をメソッド化
def select_new(element)
  return Selenium::WebDriver::Support::Select.new(element )
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

# 購入画面で入力した情報を一度削除する。
def input_purchase_information_clera
  @wait.until {@d.find_element(:id, 'number-form').displayed? rescue false || @d.find_element(:id,'card-number').displayed? rescue false }
  numframe = @d.find_element(:css,'#number-form > iframe') rescue false || numframe = @d.find_element(:css,'#card-number > iframe') rescue false
  @d.switch_to.frame numframe
  @d.find_element(:id, 'cardNumber').clear
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'expiry-form').displayed? rescue false || @d.find_element(:id,'card-exp').displayed? rescue false }
  expframe = @d.find_element(:css,'#expiry-form > iframe') rescue false || expframe = @d.find_element(:css,'#card-exp > iframe') rescue false
  @d.switch_to.frame expframe
  @d.find_element(:id, 'cardExpiry').clear
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'cvc-form').displayed? rescue false || @d.find_element(:id,'card-cvc').displayed? rescue false }
  cvcframe = @d.find_element(:css,'#cvc-form > iframe') rescue false || cvcframe = @d.find_element(:css,'#card-cvc > iframe') rescue false
  @d.switch_to.frame cvcframe
  @d.find_element(:id, 'cardCvc').clear
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'postal-code').displayed?}
  @d.find_element(:id, 'postal-code').clear
 
  @wait.until {@d.find_element(:id, 'city').displayed?}
  @d.find_element(:id, 'city').clear

  @wait.until {@d.find_element(:id, 'addresses').displayed?}
  @d.find_element(:id, 'addresses').clear

  @wait.until {@d.find_element(:id, 'phone-number').displayed?}
  @d.find_element(:id, 'phone-number').clear
end
# 郵便番号にハイフンを入れない状態で決済を行う。
def input_purchase_information_error_postal_code(card_number, card_expiry, card_cvc)
  @wait.until {@d.find_element(:id, 'number-form').displayed? rescue false || @d.find_element(:id,'card-number').displayed? rescue false }
  numframe = @d.find_element(:css,'#number-form > iframe') rescue false || numframe = @d.find_element(:css,'#card-number > iframe') rescue false
  @d.switch_to.frame numframe
  @d.find_element(:id, 'cardNumber').send_keys(card_number)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'expiry-form').displayed? rescue false || @d.find_element(:id,'card-exp').displayed? rescue false }
  expframe = @d.find_element(:css,'#expiry-form > iframe') rescue false || expframe = @d.find_element(:css,'#card-exp > iframe') rescue false
  @d.switch_to.frame expframe
  @d.find_element(:id, 'cardExpiry').send_keys(card_expiry)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'cvc-form').displayed? rescue false || @d.find_element(:id,'card-cvc').displayed? rescue false }
  cvcframe = @d.find_element(:css,'#cvc-form > iframe') rescue false || cvcframe = @d.find_element(:css,'#card-cvc > iframe') rescue false
  @d.switch_to.frame cvcframe
  @d.find_element(:id, 'cardCvc').send_keys(card_cvc)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'postal-code').displayed?}
  @d.find_element(:id, 'postal-code').send_keys(@postal_code_error)

  @wait.until {@d.find_element(:id, 'prefecture').displayed?}
  @d.find_element(:id, 'prefecture').send_keys(@prefecture)

  @wait.until {@d.find_element(:id, 'city').displayed?}
  @d.find_element(:id, 'city').send_keys(@city)

  @wait.until {@d.find_element(:id, 'addresses').displayed?}
  @d.find_element(:id, 'addresses').send_keys(@addresses)

  @wait.until {@d.find_element(:id, 'phone-number').displayed?}
  @d.find_element(:id, 'phone-number').send_keys(@phone_number)
  #カード番号情報のみ未入力状態で購入ボタンをおす
  @d.find_element(:class,"buy-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # バリデーションによるエラーメッセージ出力有無を確認
  display_flag = @d.find_element(:class,"error-alert").displayed? rescue false

  # カード情報入力画面にリダイレクトかつエラーメッセージが出力されている場合
  if /クレジットカード情報入力/ .match(@d.page_source) && display_flag
    @puts_num_array[7][10] = "[7-010] ◯"  #郵便番号の保存にはハイフンが必要であること（123-4567となる）"


  # カード情報入力画面にリダイレクトのみ
  elsif /クレジットカード情報入力/ .match(@d.page_source)
    @puts_num_array[7][10] = "[7-010] ×：郵便番号の保存にハイフンがない状態だと購入情報入力画面にリダイレクトはされるが、エラーメッセージは画面に出力されない"

    # カード番号未入力で商品購入ができてしまったら = トップページに戻ってきたら
  elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @puts_num_array[7][10] = "[7-010] ×：郵便番号の保存にハイフンがない状態でも、決済できる"
    @puts_num_array[0].push("不適切なクレジットカード決済方法で購入が完了したため自動チェックを中断します")
    raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
  else
    @puts_num_array[7][10] = "[7-010] ×"
    @puts_num_array[0].push("不適切なクレジットカード決済方法で購入が完了したため自動チェックを中断します")
    raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
  end

end

# 電話番号にハイフンを入れた状態で決済を行う。
def input_purchase_information_error_phone_number(card_number, card_expiry, card_cvc)
  @wait.until {@d.find_element(:id, 'number-form').displayed? rescue false || @d.find_element(:id,'card-number').displayed? rescue false }
  numframe = @d.find_element(:css,'#number-form > iframe') rescue false || numframe = @d.find_element(:css,'#card-number > iframe') rescue false
  @d.switch_to.frame numframe
  @d.find_element(:id, 'cardNumber').send_keys(card_number)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'expiry-form').displayed? rescue false || @d.find_element(:id,'card-exp').displayed? rescue false }
  expframe = @d.find_element(:css,'#expiry-form > iframe') rescue false || expframe = @d.find_element(:css,'#card-exp > iframe') rescue false
  @d.switch_to.frame expframe
  @d.find_element(:id, 'cardExpiry').send_keys(card_expiry)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'cvc-form').displayed? rescue false || @d.find_element(:id,'card-cvc').displayed? rescue false }
  cvcframe = @d.find_element(:css,'#cvc-form > iframe') rescue false || cvcframe = @d.find_element(:css,'#card-cvc > iframe') rescue false
  @d.switch_to.frame cvcframe
  @d.find_element(:id, 'cardCvc').send_keys(card_cvc)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'postal-code').displayed?}
  @d.find_element(:id, 'postal-code').send_keys(@postal_code)

  @wait.until {@d.find_element(:id, 'prefecture').displayed?}
  @d.find_element(:id, 'prefecture').send_keys(@prefecture)

  @wait.until {@d.find_element(:id, 'city').displayed?}
  @d.find_element(:id, 'city').send_keys(@city)

  @wait.until {@d.find_element(:id, 'addresses').displayed?}
  @d.find_element(:id, 'addresses').send_keys(@addresses)

  @wait.until {@d.find_element(:id, 'phone-number').displayed?}
  @d.find_element(:id, 'phone-number').send_keys(@phone_number_error)
  #カード番号情報のみ未入力状態で購入ボタンをおす
  @d.find_element(:class,"buy-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # バリデーションによるエラーメッセージ出力有無を確認
  display_flag = @d.find_element(:class,"error-alert").displayed? rescue false

    # カード情報入力画面にリダイレクトかつエラーメッセージが出力されている場合
    if /クレジットカード情報入力/ .match(@d.page_source) && display_flag
      @puts_num_array[7][11] = "[7-011] ◯"  #電話番号は11桁以内の数値のみ保存可能なこと（09012345678となる）"


    # カード情報入力画面にリダイレクトのみ
    elsif /クレジットカード情報入力/ .match(@d.page_source)
      @puts_num_array[7][11] = "[7-011] ×：電話番号の保存にハイフンを入れた状態だと購入情報入力画面にリダイレクトはされるが、エラーメッセージは画面に出力されない"

      # カード番号未入力で商品購入ができてしまったら = トップページに戻ってきたら
    elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
      @puts_num_array[7][11] = "[7-011] ×：電話番号の保存にハイフンを入れた状態でも、決済できる"
      @puts_num_array[0].push("不適切なクレジットカード決済方法で購入が完了したため自動チェックを中断します")
      raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
    else
      @puts_num_array[7][11] = "[7-011] ×"
      @puts_num_array[0].push("不適切なクレジットカード決済方法で購入が完了したため自動チェックを中断します")
      raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
    end
end

# 購入情報の入力(入力のみ、決済ボタンクリックまではしない)
# 前提：購入画面に遷移していること
# 引数：カード情報のみ引数化(複数枚のカード情報でのテストを行う可能性を加味)、住所情報は毎回固定
def input_purchase_information(card_number, card_expiry, card_cvc)
  # カード番号を入力した状態で再度決済を行う
  @wait.until {@d.find_element(:id, 'number-form').displayed? rescue false || @d.find_element(:id,'card-number').displayed? rescue false }
  numframe = @d.find_element(:css,'#number-form > iframe') rescue false || numframe = @d.find_element(:css,'#card-number > iframe') rescue false
  @d.switch_to.frame numframe
  @d.find_element(:id, 'cardNumber').send_keys(card_number)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'expiry-form').displayed? rescue false || @d.find_element(:id,'card-exp').displayed? rescue false }
  expframe = @d.find_element(:css,'#expiry-form > iframe') rescue false || expframe = @d.find_element(:css,'#card-exp > iframe') rescue false
  @d.switch_to.frame expframe
  @d.find_element(:id, 'cardExpiry').send_keys(card_expiry)
  @d.switch_to.default_content

  @wait.until {@d.find_element(:id, 'cvc-form').displayed? rescue false || @d.find_element(:id,'card-cvc').displayed? rescue false }
  cvcframe = @d.find_element(:css,'#cvc-form > iframe') rescue false || cvcframe = @d.find_element(:css,'#card-cvc > iframe') rescue false
  @d.switch_to.frame cvcframe
  @d.find_element(:id, 'cardCvc').send_keys(card_cvc)
  @d.switch_to.default_content

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

# 出品

# 必須項目を全て入力した上で出品

# ログイン状態
# トップページ　→　商品詳細画面(自分で出品した商品)
# 商品編集(エラーハンドリング)
def item_edit
  # トップ画面にて商品名を基準に該当の商品をクリックして商品詳細画面へ遷移する
  item_name_click_from_top(@item_name)

  # 詳細画面のURLを取得
  detail_url_coat = @d.current_url

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
 
  # 商品編集ページで戻るボタンをクリック
  @d.find_element(:class,"back-btn").click

  # 詳細ページに戻れるか確認
  if /#{@item_info}/.match(@d.page_source)
    @puts_num_array[5][6] = "[5-006] ◯"  #：ページ下部の「もどる」ボタンを押すと、編集途中の情報は破棄され、商品詳細表示ページに遷移すること"
  else
    @puts_num_array[5][6] = "[5-006] ×"  #：ページ下部の「もどる」ボタンを押しても、商品詳細表示ページに遷移できない"
    @d.get(detail_url_coat)
  end

  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click

  # 「商品の説明」項目に正常な情報を入力して編集してみる
  @wait.until {@d.find_element(:id,"item-info").displayed? rescue @d.find_element(:id,"item-description").displayed? }
  @puts_num_array[5][5] = "[5-005] ◯" #ログイン状態の出品者のみ、出品した商品の商品情報編集ページに遷移できること
  @d.find_element(:id,"item-info").send_keys(@item_info_re) rescue @d.find_element(:id,"item-description").send_keys(@item_info_re)
  @d.find_element(:class,"sell-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}


  # 稀に編集画面に遷移した際に値を保持していない実装をしている受講生がいるため、商品詳細画面に遷移できているかあぶり出すチェック項目
  if /#{@item_info_re}/.match(@d.page_source)
    @puts_num_array[5][2] = "[5-002] ◯"  #：必要な情報を適切に入力すると、商品情報（商品画像・商品名・商品の状態など）を変更できること"
    @puts_num_array[5][7] = "[5-007] ◯"  #：編集が完了したら、商品詳細表示ページに遷移し、変更された商品情報が表示されること"
  elsif /#{@item_info}/.match(@d.page_source)
    @puts_num_array[5][2] = "[5-002] ×：商品編集画面にて「商品説明」を編集し確定させたが、編集前の情報が表示されている"
    @puts_num_array[5][7] = "[5-007] ◯"  #：編集が完了したら、商品詳細表示ページに遷移し、変更された商品情報が表示されること"
  elsif /FURIMAが選ばれる3つの理由/.match(@d.page_source)
    @puts_num_array[5][2] = "[5-002] △：商品編集画面にて「商品説明」を編集し確定させるとトップページへ遷移してしまう設計のため、「商品説明」項目を確認できず。手動確認"
    @puts_num_array[5][7] = "[5-007] ×"  #：編集が完了しても、商品詳細表示ページに遷移できない"
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
    @puts_num_array[3][2] = "[3-002] ◯"  #：商品一覧表示ページは、ログイン状況に関係なく、誰でも見ることができること"
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
  # 101期以降削除
  if @flag_4_001 == 2
    @puts_num_array[5][4] = "[5-004]【101期以降削除】 ◯"  #：ログイン状態の出品者のみ、出品した商品の商品情報を編集できること"
  else
    @puts_num_array[5][4] = "[5-004]【101期以降削除】 ×：[4-001]チェックにて×が発生しているため"  #：出品者だけが編集ページに遷移できる"
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
  check_21

  # check_22メソッドの中でログアウトしているためuser2でログイン
  login_any_user(@email2, @password)
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class, "item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click

  #クレジットカード情報入力画面に遷移
  # 購入情報の入力(入力のみ、決済ボタンクリックまではしない)
  input_purchase_information(@card_number, @card_expiry,  @card_cvc)

  # カード番号の項目のみ削除
  numframe = @d.find_element(:css,'#number-form > iframe') rescue false || numframe = @d.find_element(:css,'#card-number > iframe') rescue false
  @d.switch_to.frame numframe
  @d.find_element(:id, 'cardNumber').clear
  @d.switch_to.default_content

  #カード番号情報のみ未入力状態で購入ボタンをおす
  @d.find_element(:class,"buy-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # バリデーションによるエラーメッセージ出力有無を確認
  display_flag = @d.find_element(:class,"error-alert").displayed? rescue false

  # カード情報入力画面にリダイレクトかつエラーメッセージが出力されている場合
  if /クレジットカード情報入力/ .match(@d.page_source) && display_flag
    @puts_num_array[7][7] = "[7-007] ◯"  #入力に問題がある状態で購入ボタンが押されたら、購入ページに戻りエラーメッセージが表示されること"


  # カード情報入力画面にリダイレクトのみs
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

  # 【追記する。】puts "◯クレジットカード情報は必須であり、正しいクレジットカードの情報で無いときは決済できない"  #正常な値での登録チェックを行っていないため未実証
  # 購入画面で入力した情報を一度削除する。
  input_purchase_information_clera
  # 郵便番号にハイフンを入れない状態で決済を行う。
  input_purchase_information_error_postal_code(@card_number, @card_expiry,  @card_cvc)
   # 購入画面で入力した情報を一度削除する。
  input_purchase_information_clera
  
  # 電話番号にハイフンを入れた状態で決済を行う。
  input_purchase_information_error_phone_number(@card_number, @card_expiry,  @card_cvc)
  input_purchase_information_clera
  # カード番号を入力した状態で再度決済を行う
  input_purchase_information(@card_number, @card_expiry,  @card_cvc)


  #正常に決済する
  @d.find_element(:class,"buy-red-btn").click


  @wait.until {@d.find_element(:class,"furima-icon").displayed?}

  #：購入が完了したら、トップページまたは購入完了ページに遷移する"
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source) then @puts_num_array[7][6] = "[7-006] ◯" end

  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  @puts_num_array[7][2] = "[7-002] ◯"  #クレジットカードの情報は購入の都度入力させること"  #これは立証できていない
  @puts_num_array[7][3] = "[7-003] ◯"  #配送先の住所情報も購入の都度入力させること"
  @puts_num_array[7][4] = "[7-004] ◯"  #クレジットカード情報は必須であり、右記のPAY.JPテストカードの情報で決済ができること"
  @puts_num_array[7][8] = "[7-008] ◯"  #必要な情報を適切に入力すると、商品の購入ができること
  @puts_num_array[7][12] = "[7-012] ◯"  #ログイン状態の場合は、自身が出品していない販売中商品の商品購入ページに遷移できること

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
      @puts_num_array[7][9] = "[7-009] 【101期以降削除】◯ ← △：しかし、購入ボタンを押してもトップページに遷移するので購入した商品は、再度購入できない状態になっているためOK"
    else
      @puts_num_array[7][9] = "[7-009]【101期以降削除】 × ← △：また「購入ボタン」を押すとトップページ以外の画面に遷移する状態になっている"
      @d.get(@url)
    end
    # 84期まではログアウトユーザーが詳細画面を見ても「購入画面に進む」ボタンが表示されていてもOK(クリックするとトップに戻ること)
    # 85期からは「購入画面に進む」ボタンの表示自体がNG

  else
    @puts_num_array[7][9] = "[7-009]【101期以降削除】◯"  #：ログイン状態の出品者以外のユーザーのみ、「購入画面に進む」ボタンが表示されること"
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

  # 販売手数料と販売利益が整数であるかをチェック
  check_22

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
  # input_purchase_information(@card_number, @card_expiry,  @card_cvc)

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
  # 【114期以降廃止】削除完了画面等があっても処理が止まらないように一度トップページへ遷移しておく
  # @d.get(@url)
  # @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 最新出品商品名 = 「サングラス」以外の商品名(サングラスを削除したため)
  # トップページに表示されている一番最初の商品名を取得
  latest_item_name = @d.find_element(:class,"item-name").text
  if latest_item_name == @item_name2
    @puts_num_array[6][1] = "[6-001] ×：ログイン状態の出品者が出品した商品情報を削除できない(商品一覧画面から削除できていない)"
    @puts_num_array[6][2] = "[6-002] ×：削除が完了しても、トップページに遷移できない"
  else
    @puts_num_array[6][1] = "[6-001] ◯"  #：出品者だけが商品情報を削除できる"
    @puts_num_array[6][2] = "[6-002] ○"  #：削除が完了したら、トップページに遷移すること"
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

#商品が出品されていない状態では、ダミーの商品情報が表示されること
def check_dummy_item
  if /商品を出品してね！/.match(@d.page_source)
    @puts_num_array[3][3] = "[3-003] ○" #商品が出品されていない状態では、ダミーの商品情報が表示されること"
  else
    @puts_num_array[3][3] = "[3-003] × :商品が出品されていない状態では、ダミーの商品情報が表示されてない。またはデータがリセットされていない"  #：出品者だけが商品情報を削除できる"
  end
end

# 自動チェック処理の終了のお知らせ
def finish_puts
  @puts_num_array[0].push("自動チェックツール全プログラム終了")
  @puts_num_array[0].push("\n\n自動チェック途中にuserアカウント情報の変更を行う場合があるため、手動チェック時は以下の最終確定アカウント情報をお使いください")
  @puts_num_array[0].push("パスワード: #{@users[0][:password]} (全ユーザー共通)\n")
  @puts_num_array[0].push("ユーザー名: lifecoach_test_user1\nemail: #{@users[0][:email]}\n\nユーザー名: lifecoach_test_user2\nemail: #{@users[1][:email]}\n\nユーザー名: lifecoach_test_user3\nemail: #{@users[2][:email]}\n\n")
end