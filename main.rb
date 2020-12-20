# チェック項目のメソッドをまとめているファイル
require './check_list'
# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
require 'ruby_jard'

# メモ
# 購入時に起こっていたエラー詳細
# item-red-btn = 商品詳細画面での商品の編集 or 購入のボタン
# buy-red-btn  = 購入画面での購入ボタン


def main

  # start

  # basic認証が実装されている
  check_14

  @http ="http://#{@b_id}:#{@b_password}@"
# 受講生の@URLをhttp://以降から記入
  @url = @http + @url_ele
  # @url = "http://#{b_id}:#{b_password}@localhost:3000/"

  @d.get(@url)

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
  # ニックネーム,誕生日未入力
  sign_up_nickname_input

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
  # 画像なしで出品トライ
  item_new_no_image
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

  # 購入後の商品状態や表示方法をチェック
  login_user2_after_purchase_check1


  # ユーザー状態：user2
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = なし

  # user2による出品(サングラス)
  login_user2_item_new

  # ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること
  # サングラス　→　コートの順に出品されているかチェック
  check_4

  # ユーザー状態：user1
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = user1

  # ログアウト → user1でログイン
  # サングラス購入
  login_user1_item_buy

  # ユーザー状態：ログアウト
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = user1

  # ログアウトしたユーザーで購入できるかチェック
  no_user_item_buy

  # 価格の範囲が、¥300~¥9,999,999の間であること
  # 出品を何度かしてチェック
  check_13

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

「①動作チェックするアプリの本番環境URL」を入力しenterキーを押してください
EOT

  input_url = gets.chomp
  # 「https://」を削除
  @url_ele = input_url.gsub(/https:\/\//,"")
  puts "次に「②basic認証[ユーザー名]」を入力しenterキーを押してください"
  @b_id= gets.chomp
  puts "次に「③basic認証[パスワード]」を入力しenterキーを押してください"
  @b_password = gets.chomp

  puts "自動チェックを開始します"

end

# よく使う冗長なコードをメソッド化
def select_new(element)
  return Selenium::WebDriver::Support::Select.new(element )
end

def two_class_displayed_check(first_ele, second_ele)
  f_flag = @d.find_element(:class,second_ele).displayed? rescue false
  s_flag = @d.find_element(:class,first_ele).displayed? rescue false
  if f_flag || s_flag then return true end
  return false
end

# ユーザーのログイン
def login_any_user(email, pass)
  @d.get(@url)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  # ログイン状態であればログアウトしておく
  if (@d.find_element(:class,"logout").displayed? rescue false)
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

# 商品出品時の入力項目へ入力するメソッド
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
def click_purchase_btn(flag)

  # 出品ボタンを押して画面遷移できるかどうか
  if /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn").click
    if flag then puts "!出品ページに遷移 ※[class: purchase-btn]で遷移" end
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    if flag then puts "!出品ページに遷移 ※[class: purchase-btn-text]で遷移" end
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-icon").click
    if flag then puts "!出品ページに遷移 ※[class: purchase-btn-icon]で遷移" end
  else
    puts "×：トップ画面から出品ページに遷移できない"
    raise '以降の自動チェックに影響を及ぼす致命的なエラーのため、処理を中断します。手動チェックに切り替えてください'
  end
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
end

# トップ画面にて商品名を基準に該当の商品をクリックして商品詳細画面へ遷移する
def item_name_click_from_top(name)
  items = @d.find_elements(:class,"item-name")
  # 商品名を判別してクリック
  items.each{|item|
    if item.text == name then item.click end
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
    break
  }
end

# 直前に出品した商品を削除して再度出品画面に戻る
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






# 新規登録
# ニックネームは未入力
def sign_up_nickname_input
  @d.find_element(:class,"sign-up").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 新規登録に必要な項目入力を行うメソッド
  input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)

  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').clear

  @d.find_element(:class,"register-red-btn").click
end

# まだ登録が完了していない場合、再度登録
def sign_up_retry

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /会員情報入力/ .match(@d.page_source)
    puts "◯：ニックネームを入力しないと、ユーザー登録ができない。"
    puts "◯：必須項目が一つでも欠けている場合は、ユーザー登録ができない"

  else
    puts "×：ニックネームを入力しなくても、ユーザー登録ができる"
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
    randm_word = SecureRandom.hex(5)
    @email = "user1_#{randm_word}@co.jp"
  end

  # 目視ではなくメソッドとして詳細をlogに書き込む
  sleep 3
  puts "◯【目視で確認】エラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）"

  # 再度登録
  # まず入力の準備として項目情報をクリア
  clear_sign_up_method

  # 今度はニックネーム含めた全項目に情報を入力していく
  input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)

  @d.find_element(:class,"register-red-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "◯必須項目を入力し、ユーザー登録ができる"
    puts "◯ニックネームが必須である"
    puts "◯メールアドレスが必須である"
    puts "◯メールアドレスは一意性である"  #これはまだ立証できない
    puts "◯メールアドレスは@を含む必要がある"  #これはまだ立証できない
    puts "◯パスワードが必須である"
    puts "◯パスワードは6文字以上である"  #これはまだ立証できない
    puts "◯パスワードは半角英数字混合である"  #これはまだ立証できない
    puts "◯パスワードは確認用を含めて2回入力する"  #これはまだ立証できない
    puts "◯ユーザー本名が、名字と名前がそれぞれ必須である"  #これはまだ立証できない
    puts "◯ユーザー本名は全角（漢字・ひらがな・カタカナ）で入力させる"  #これはまだ立証できない
    puts "◯ユーザー本名のフリガナが、名字と名前でそれぞれ必須である"
    puts "◯ユーザー本名のフリガナは全角（カタカナ）で入力させる"
    puts "◯生年月日が必須である"  #これはまだ立証できない
  
  # 登録に失敗した場合はパスワードを疑う
  elsif /会員情報入力/ .match(@d.page_source)
    puts "×：パスワードに大文字が入っていないと登録できない可能性あり、パスワード文字列に大文字(aaa111 → Aaa111)を追加して再登録トライ"

    # パスワードの内容でエラーになった可能性あるため、大文字含めた文字列に変更
    @password = "Aaa111"
    clear_sign_up_method
    input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)
    @d.find_element(:class,"register-red-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)

      puts "◯必須項目を入力し、ユーザー登録ができる" 
      puts "◯ニックネームが必須である"
      puts "◯メールアドレスが必須である"
      puts "◯メールアドレスは一意性である"  #これはまだ立証できない
      puts "◯メールアドレスは@を含む必要がある"  #これはまだ立証できない
      puts "◯パスワードが必須である"
      puts "◯パスワードに大文字が含まれていることが必須である"  #追記
      puts "◯パスワードは6文字以上である"  #これはまだ立証できない
      puts "◯パスワードは半角英数字混合である"  #これはまだ立証できない
      puts "◯パスワードは確認用を含めて2回入力する"  #これはまだ立証できない
      puts "◯ユーザー本名が、名字と名前がそれぞれ必須である"  #これはまだ立証できない
      puts "◯ユーザー本名は全角（漢字・ひらがな・カタカナ）で入力させる"  #これはまだ立証できない
      puts "◯ユーザー本名のフリガナが、名字と名前でそれぞれ必須である"
      puts "◯ユーザー本名のフリガナは全角（カタカナ）で入力させる"
      puts "◯生年月日が必須である"  #これはまだ立証できない

    
      # パスワードの上書きでも登録が成功しない場合は処理を終了
    else
      puts "☒必須項目を入力してもユーザー登録ができていない" 
      puts "ユーザー登録バリデーションが複雑なためuser1が登録できません。ユーザー登録できない場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します"
      puts "手動でのアプリチェックを行ってください"
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

  # トップ画面に戻れているか
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "◯ログイン/ログアウトができる"
  else
    puts "☒ログイン/ログアウトができない"
    @d.get(@url)
  end
end

# 出品
# 画像添付なし
def item_new_no_image

  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  # 出品ボタンをクリック
  click_purchase_btn(true)

  # 商品出品時の必須項目へ入力するメソッド
  input_item_new_method(@item_name, @item_info, @item_price, @item_image)

  # 商品画像のみ空白
  @d.find_element(:id,"item-image").clear

  # 入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)
  check_17

  # 「出品する」ボタンをクリック
  @d.find_element(:class,"sell-btn").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /商品の情報を入力/.match(@d.page_source)
    puts "◯画像が0枚の場合は、出品できない"
  else
    puts "☒画像が0枚の場合でも、出品できてしまう"
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  end
end



# 出品
# 価格未入力
def item_new_price_uninput

  # 再出品するために必須項目を全クリア
  clear_item_new_method

  # 商品出品時の必須項目へ入力するメソッド
  input_item_new_method(@item_name, @item_info, @item_price, @item_image)

  # 商品価格のみ空白
  @d.find_element(:id,"item-price").clear

  @d.find_element(:class,"sell-btn").click

  if /商品の情報を入力/.match(@d.page_source)
    puts "!価格の記入なしで商品出品を行うと、商品出品ページリダイレクトされる"
  else
    puts "!価格の記入なしで商品出品を行っても、商品出品ページリダイレクトされない"
  end

  puts "◯必須項目が一つでも欠けている場合は、出品ができない"
  sleep 1

end

# 必須項目を全て入力した上で出品
# エラーハンドリングのチェック
def item_new_require_input

  puts '◯【目視で確認】エラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）'
  clear_item_new_method

  input_item_new_method(@item_name, @item_info, @item_price, @item_image)

  # 商品情報のセレクトタグにて選択した情報を変数に代入
  @item_category_word            = select_new(@d.find_element(:id,"item-category")).selected_options[0].text
  @item_status_word              = select_new(@d.find_element(:id,"item-sales-status")).selected_options[0].text
  @item_shipping_fee_status_word = select_new(@d.find_element(:id,"item-shipping-fee-status")).selected_options[0].text
  @item_prefecture_word          = select_new(@d.find_element(:id,"item-prefecture")).selected_options[0].text
  @item_scheduled_delivery_word  = select_new(@d.find_element(:id,"item-scheduled-delivery")).selected_options[0].text

  puts "◯画像は1枚必須である"
  puts "◯商品名が必須である"
  puts "◯商品の説明が必須である"
  puts "◯カテゴリーの情報が必須である"
  puts "◯商品の状態についての情報が必須である"
  puts "◯配送料の負担についての情報が必須である"
  puts "◯発送元の地域についての情報が必須である"
  puts "◯発送までの日数についての情報が必須である"
  puts "◯価格についての情報が必須である"
  puts "◯販売価格は半角数字のみ入力可能"

  @d.find_element(:class,"sell-btn").click

  if /#{@item_name}/ .match(@d.page_source)
    puts "!有効な情報を入力するとトップページへ遷移し、商品名が表示されている。" 
  else
    puts "!有効な情報を入力しても、商品名が表示されない。" 
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end



  if /#{@item_image_name}/ .match(@d.page_source)
    puts "！有効な情報を入力するとトップページへ遷移し、画像が表示されている。" 
  else
    puts "!有効な情報を入力しても、画像が表示されない" 
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end



  if /#{@item_price}/.match(@d.page_source)
    puts "!有効な情報を入力するとトップページへ遷移し、商品価格が表示されている。" 
  else
    puts "!有効な情報を入力しても商品価格が表示されない" 
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end

  puts "◯必須項目を入力した上で出品ができる"
  puts "◯出品した商品の一覧表示ができている"
  puts "◯「画像/価格/商品名」の3つの情報について表示できている"
end

# ログイン状態
# トップページ　→　商品詳細画面(自分で出品した商品)
# 商品編集(エラーハンドリング)
def item_edit
  # トップ画面にて商品名を基準に該当の商品をクリックして商品詳細画面へ遷移する
  item_name_click_from_top(@item_name)
  # 商品詳細画面
  if /編集/.match(@d.page_source)
    puts "!ログインした上で自分が出品した商品詳細ページへアクセスした場合は、「編集」のリンクが表示される" 
  else
    puts "!ログインした上で自分が出品した商品詳細ページへアクセスしたが、「編集」のリンクが表示されない" 
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
  end

  if /削除/.match(@d.page_source)
    puts "!ログインした上で自分が出品した商品詳細ページへアクセスした場合は、「削除」のリンクが表示される" 
  else
    puts "!ログインした上で自分が出品した商品詳細ページへアクセスしたが、「削除」のリンクが表示されない" 
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
  end

  jard
  # 商品詳細ページで商品出品時に登録した情報が見られるようになっている
  check_18

  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  # 商品編集ボタンクリック
  @d.find_element(:class,"item-red-btn").click

  # 商品出品時とほぼ同じ見た目で商品情報編集機能が実装されていること
  check_7

  # ログアウト状態のユーザーは、URLを直接入力して商品情報編集ページへ遷移しようとすると、ログインページに遷移すること
  check_8

  # 別ウィンドウにて異なるユーザーでログインした際はウィンドウを元に戻す時は再度ログインし直す
  @d.get(@url)
  # 元のuser1でログイン
  login_any_user(@email, @password)

  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  # 商品編集ボタンクリック
  @d.find_element(:class,"item-red-btn").click

  # 「商品の説明」項目を空白にして再度出品してみる
  @d.find_element(:id,"item-info").clear
  @d.find_element(:class,"sell-btn").click
  if /商品の情報を入力/.match(@d.page_source)
    puts "◯無効な情報で商品編集を行うと、商品編集ができない" 
  else
    puts "☒無効な情報でも商品編集を行うと、商品編集ができる" 
    @wait.until {@d.find_element(:id,"sell-btn").displayed?}
  end

  sleep 1
  puts "【目視で確認】エラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）"

  # 「商品の説明」項目に正しい値を入力して再度出品してみる
  @d.find_element(:id,"item-info").send_keys(@item_info_re)
  @d.find_element(:class,"sell-btn").click

  # 稀に編集画面に遷移した際に値を保持していない実装をしている受講生がいるため、商品詳細画面に遷移できているかあぶり出すチェック項目
  if /#{@item_info_re}/.match(@d.page_source)
    puts "◯商品名やカテゴリーの情報など、すでに登録されている商品情報は編集画面を開いた時点で表示される"
  elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @d.find_element(:class,"item-img-content").click
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
    puts "◯商品名やカテゴリーの情報など、すでに登録されている商品情報は編集画面を開いた時点で表示される"
  else
    puts "☒商品説明が表示されないまたは、商品名やカテゴリーの情報など、すでに登録されている商品情報は編集画面を開いた時点で表示されない" 
    # 必要な情報が入力された状態で編集確定されると商品詳細画面に戻ってくるため、detail-itemが表示されるが正解
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
  end


  # ◯商品情報（商品画像・商品名・商品の状態など）を変更できる
  puts "◯何も編集せずに更新をしても画像無しの商品にならない"
  puts "◯商品情報（商品画像・商品名・商品の状態など）を変更できる"
end

# ログアウトしてから商品の編集や購入ができるかチェック
def logout_item_edit_and_buy
  # ヘッダーのトップへ遷移するアイコンをクリック
  @d.find_element(:class,"furima-icon").click

  # ログアウトをクリック
  @d.find_element(:class,"logout").click
  # ログアウト後のトップページで「出品する」ボタンをクリック
  if /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn").click
    puts "!出品ページに遷移1"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    puts "!出品ページに遷移2"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-icon").click
    puts "!出品ページに遷移3"
  else
    puts "!出品ページに遷移できない"
  end

  # ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること
  check_9


  # トップページにて出品された商品一覧(商品画像)が表示されているかどうか
  @wait.until {@d.find_element(:class, "item-img-content").displayed?}
  if /#{@item_image_name}/ .match(@d.page_source)
    puts "!ログアウト状態で、トップ画面にて商品の一覧表示を確認でき、出品画像が表示されている" 
  else
    puts "!ログアウト状態だとトップ画面にて出品画像が表示されない"
  end

  item_name = @d.find_element(:class,'item-name')
  puts "!商品名は" + item_name.text

  item_price = @d.find_element(:class,'item-price')
  puts "!商品価格は" + item_price.text

  # 商品詳細画面へ遷移
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 商品詳細ページでログアウト状態のユーザーには、「編集・削除・購入画面に進むボタン」が表示されないこと
  check_11

  puts "【説明】購入ボタン自体を消しているてる場合があるので一度、サインアップする"

end

# 別名義のユーザーで登録 & ログイン
def login_user2

  @wait.until {@d.find_element(:class,"sign-up").displayed?}
  @d.manage.delete_all_cookies
  @d.find_element(:class,"sign-up").click
  puts "新しいユーザーを登録する"
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

  # 「商品出品」ボタンが存在するかチェック
  # トップページかどうか
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?} rescue puts "Error: class:purchase-btnが見つかりません"

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
  if /編集/ .match(@d.page_source)
    puts "!ログインした上で自分が出品していない商品詳細ページへアクセスした場合に、「編集」のリンクが表示される" 
    @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  else
    puts "!ログインした上で自分が出品していない商品詳細ページへアクセスした場合は、「編集」のリンクが表示されない" 
  end


  if /削除/ .match(@d.page_source)
    puts "!ログインした上で自分が出品していない商品詳細ページへアクセスした場合に、「削除」のリンクが表示される" 
    @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  else
    puts "!ログインした上で自分が出品していない商品詳細ページへアクセスした場合は、「削除」のリンクが表示されない" 
  end
  puts "◯出品者にしか、商品編集・削除のリンクが踏めないようになっている"
  puts "◯出品者だけが編集ページに遷移できる"

  @wait.until {@d.find_element(:class, "item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click

  # 購入画面のURLをputsする理由とは？ = 途中でエラーが起こった場合に踏むURL保持しておくため
  @order_url_coat = @d.current_url
  puts "コート購入画面のURL→  " + @order_url_coat

  # コート購入前にチェック
  check_5

  login_any_user(@email2, @password)
  @d.find_element(:class,"item-img-content").click
  @wait.until {@d.find_element(:class, "item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click

  #クレジットカード情報入力画面に遷移
  @wait.until {@d.find_element(:id, 'card-exp-month').displayed?}
  @d.find_element(:id, 'card-exp-month').send_keys(@card_exp_month)

  @wait.until {@d.find_element(:id, 'card-exp-year').displayed?}
  @d.find_element(:id, 'card-exp-year').send_keys(@card_exp_year)

  @wait.until {@d.find_element(:id, 'card-cvc').displayed?}
  @d.find_element(:id, 'card-cvc').send_keys(@card_cvc)

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


  @d.find_element(:class,"buy-red-btn").click


  if /クレジットカード情報入力/ .match(@d.page_source)
    puts "!カード番号が入力されていない無い場合は、決済できない" 
  else
    puts "!カード番号が入力されていない無い場合でも、決済できる" 
    @wait.until {@d.find_element(:class,"sold-out").displayed?}
  end

  puts "◯クレジットカード情報は必須であり、正しいクレジットカードの情報で無いときは決済できない"
  sleep 3
  puts "◯【目視で確認】エラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）"
  #アラートが出るとエラーがでる

  if /#{@item_name}/.match(@d.page_source)
    puts "☒ログインしていないユーザーでも、商品の編集が行える" 
    @wait.until {@d.find_element(:class,"buy-red-btn").displayed?}
  else
    puts "◯ログインしていないユーザーは、商品の編集が行えない。" 
  end


  @wait.until {@d.find_element(:id, 'card-number').displayed?}
  @d.find_element(:id, 'card-number').send_keys(@card_number)
  puts "【説明】クレジットカードの番号記入"
  @wait.until {@d.find_element(:id, 'card-exp-month').displayed?}
  @d.find_element(:id, 'card-exp-month').send_keys(@card_exp_month)
  puts "【説明】クレジットカードの有効月を記入"
  @wait.until {@d.find_element(:id, 'card-exp-year').displayed?}
  @d.find_element(:id, 'card-exp-year').send_keys(@card_exp_year)
  puts "【説明】クレジットカードの有効年を記入"
  @wait.until {@d.find_element(:id, 'card-cvc').displayed?}
  @d.find_element(:id, 'card-cvc').send_keys(@card_cvc)
  puts "◯購入時、クレジットカードの情報を都度入力できる"
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
  puts "◯購入時、配送先の住所情報も都度入力できる"



  @d.find_element(:class,"buy-red-btn").click


  @wait.until {@d.find_element(:class,"furima-icon").displayed?}
  puts "◯クレジットカード決済ができる"
  puts "◯クレジットカードの情報は購入の都度入力させる"
  puts "◯配送先の情報として、郵便番号・都道府県・市区町村・番地・電話番号が必須であること"
  puts "◯郵便番号にはハイフンが必要であること（123-4567となる）"
  puts "◯電話番号にはハイフンは不要で、11桁以内である"
  puts "◯購入が完了したら、トップページまたは購入完了ページに遷移する"
  # もし購入完了後に購入完了ページへ遷移するのであればトップページへ遷移させる処理が必要では？
  # A：後々トップページへ遷移する処理を挟みたい
end

# 購入後の商品状態や表示方法をチェック
def login_user2_after_purchase_check1

  login_any_user(@email2, @password)

  # トップページでの表記をチェック
  if /Sold Out/ .match(@d.page_source)
    puts "◯売却済みの商品は、「sould out」の文字が表示されるようになっている" 
  else
    puts "☒売却済みの商品は、「sould out」の文字が表示されない" 
    @wait.until {@d.find_element(:class,"sold-out").displayed?}
  end


  @d.get(@order_url_coat)
  # アイコンが表示されるまで待機
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "◯@URLを直接入力して購入済みの商品ページへ遷移しようとすると、トップページに遷移する"
  else
    puts "☒@URLを直接入力して購入済みの商品ページへ遷移しようとすると、トップページに遷移しない"
  end

  @d.get(@url)

  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

  @wait.until {@d.find_element(:class,"item-img-content").displayed?}

  # 一度購入した商品の商品詳細画面へすすむ
  @d.find_element(:class,"item-img-content").click
  
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  if /購入画面に進む/ .match(@d.page_source)
    puts "!購入した商品だが、再度購入ボタンが表示されている"
    @d.find_element(:class,"item-red-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

    # 遷移先の画面に出品ボタンの有無でトップページに遷移したかを判断
    if @d.find_element(:class,"purchase-btn").displayed?
      puts "◯しかし、押してもトップページに遷移するので購入した商品は、再度購入できない状態になっている"
    else
      puts "×「購入ボタン」を押すとトップページ以外の画面に遷移する状態になっている"
      @d.get(@url)
    end
    # 84期まではログアウトユーザーが詳細画面を見ても「購入画面に進む」ボタンが表示されていてもOK(クリックするとトップに戻ること)
    # 85期からは「購入画面に進む」ボタンの表示自体がNG

  else
    puts "!一度購入した商品には再度購入ボタンが表示されない"

    @d.get(@url)
  end

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  
  if /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn").click
    puts "!出品ページに遷移1"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    puts "!出品ページに遷移2"
  elsif /出品する/ .match(@d.page_source)
      @d.find_element(:class,"purchase-btn-icon").click
      puts "!出品ページに遷移3"
  else
    puts "!出品ページに遷移できない"
  end
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
end

# user2によるサングラス出品
def login_user2_item_new
  @wait.until {@d.find_element(:id,"item-image").displayed?}
  @d.find_element(:id,"item-image").send_keys(@item_image2)
  @d.find_element(:id,"item-name").send_keys(@item_name2)
  @d.find_element(:id,"item-info").send_keys(@item_info2)
  item_category_element = @d.find_element(:id,"item-category")
  item_category = select_new(item_category_element)
  item_category.select_by(:value, @value)
  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = select_new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)
  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = select_new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)
  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = select_new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)
  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = select_new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)
  @d.find_element(:id,"item-price").send_keys(@item_price2)
  @d.find_element(:class,"sell-btn").click
end

# user2が出品したサングラスをuser1が購入する
def login_user1_item_buy
  # 出品完了後、トップページからログアウト
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:class,"logout").click

  #user1で再度ログイン
  @d.find_element(:class,"login").click 
  @d.find_element(:id, 'email').send_keys(@email)
  @d.find_element(:id, 'password').send_keys(@password)
  @d.find_element(:class,"login-red-btn").click
  @wait.until {@d.find_element(:class,"item-img-content").displayed?}
  @d.find_element(:class,"item-img-content").click 

  # 購入画面へ
  @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  @d.find_element(:class,"item-red-btn").click
  # 購入は確定させずにURLのみ取得
  @order_url_glasses = @d.current_url
  puts "サングラス購入画面の@URL→  "+ @order_url_glasses
  @d.get(@url)
end

# ログアウト状態で商品購入
def no_user_item_buy
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:class,"logout").click

  @d.get(@order_url_glasses)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /会員情報入力/ .match(@d.page_source)
    # ログインページへ遷移するのが正解
    puts "！ログインしていない状態で@URLを直接入力し購入ページに遷移しようとするとログインページに遷移する"
    puts "◯ログインしていないユーザーは購入ページに遷移しようとすると、ログインページに遷移する"
  else
    # ログインページに遷移しなかったらログインページへ遷移させる
    puts "☒ログインしていないユーザーは購入ページに遷移しようとしても、ログインページに遷移しない"
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    @d.find_element(:class,"sign-up").click
  end


  #user2(サングラスの出品者)でログイン
  @wait.until {@d.find_element(:id,"email").displayed?}
  @d.find_element(:id, 'email').send_keys(@email2)
  @d.find_element(:id, 'password').send_keys(@password)
  @d.find_element(:class,"login-red-btn").click

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  @d.get(@order_url_glasses)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "◯出品者は@URLを直接入力して購入ページに遷移しようとすると、トップページに遷移する"
  else
    puts "☒出品者が@URLを直接入力して購入ページに遷移しようとすると、トップページに遷移しない"
    @d.get(@url)
  end


  @wait.until {@d.find_element(:class,"item-img-content").displayed?}
  @d.find_element(:class,"item-img-content").click

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /購入画面に進む/ .match(@d.page_source)
    puts "☒出品者でも、商品購入のリンクが踏めるようになっている"
  else
    puts "◯出品者以外にしか、商品購入のリンクが踏めないようになっている" 
  end

  # 商品削除ボタン
  @wait.until {@d.find_element(:class,"item-destroy").displayed?}
  @d.find_element(:class,"item-destroy").click

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 最新出品商品名 = 「サングラス」以外の商品名
  latest_item_name = @d.find_element(:class,"item-name").text
  if latest_item_name == @item_name2
    puts "☒出品者が商品詳細ページで削除ボタンを押しても削除できない"
  else
    puts "◯出品者だけが商品情報を削除できる"
  end



  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:class,"logout").click
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

  # 要素が取得できなければeach処理を行わないためのfalse
  all_items = @d.find_elements(:class,"item-name") rescue false

  if all_items
    # トップページにコートが存在するかのフラグ
    item1_flag = false
    all_items.each{|ele|
      # 商品名があればフラグをtrueにする
      if ele.text == @item_name then item1_flag = true end
    }

    if item1_flag == true
      puts "◯ログアウトした状態でも、商品一覧を閲覧できる"
    else
      puts "☒ログアウトすると、商品一覧を閲覧できない"
      puts "☒伴ってログアウトした際の商品詳細画面での商品説明の有無は確認できない"
    end
  else
    puts "☒ログアウトすると、商品一覧を閲覧できない"
    puts "☒伴ってログアウトした際の商品詳細画面での商品説明の有無は確認できない"
  end

  # トップページに商品画像が存在していたら商品説明のチェックを行う
  if @d.find_element(:class,"item-img-content").displayed?
    @d.find_element(:class,"item-img-content").click

    # 商品説明の情報の有無チェック
    @wait.until{@d.find_element(:class,"item-explain-box")}
    if @d.find_element(:class,"item-explain-box").text == @item_info_re
      puts  "!【商品説明は表示できている】" + @d.find_element(:class,"item-explain-box").text
    else
      puts "☒商品説明が表示されない"
    end
    puts "◯ログアウトした状態でも、商品詳細ページを閲覧できる"
  end
end

# 自動チェック処理の終了のお知らせ
def finish_puts
  puts "プログラム終了"
  puts "ログイン情報1 user1_email #{@email} password #{@password}"
  puts "ログイン情報2 user2_email #{@email2} password #{@password}\n\n\n"
end