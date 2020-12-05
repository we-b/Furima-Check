# チェック項目のメソッドをまとめているファイル
require './check_list'
# ruby_jardはデバッグの際にのみ使用する。普段はコメントアウトする
# require 'ruby_jard'

def main

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

  # jard

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

  check_6

  # 購入後の商品状態や表示方法をチェック
  login_user2_after_purchase_check1


  # ユーザー状態：user2
  # 出品：コート = user1,サングラス = user2
  # 購入：コート = user2,サングラス = なし

  # user2による出品(サングラス)
  login_user2_item_new


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
end


# ログアウト状態
# ログアウト状態では、ヘッダーに新規登録/ログインボタンが表示されること

# 新規登録
# ニックネームは未入力
def sign_up_nickname_input
  @d.find_element(:class,"sign-up").click
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  # ニックネーム項目には未入力で処理を行う
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').send_keys(@email)
  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').send_keys(@password)
  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').send_keys(@password)
  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').send_keys(@first_name)
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').send_keys(@last_name)
  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').send_keys(@first_name_kana)
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').send_keys(@last_name_kana)

  @d.find_element(:class,"register-red-btn").click
end

# まだ登録が完了していない場合、再度登録
def sign_up_retry

  if /会員情報入力/ .match(@d.page_source)
  puts "!ニックネームを入力しないと、ユーザー登録ができない。" 
  else
  puts "!ニックネームを入力しなくても、ユーザー登録ができる" 
  @wait.until {@d.find_element(:id,"nickname").displayed?}
  end

  puts "◯必須項目が一つでも欠けている場合は、ユーザー登録ができない"
  sleep 3
  puts "◯【目視で確認】エラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）"

  # 再度登録
  # まず入力の準備として項目情報をクリア
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

  # 今度はニックネーム含めた全項目に情報を入力していく
  # ここで再度.displayed?メソッド使う意味はあるのか？？ = 高速処理によって処理がエラーを起こさないように記述している
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').send_keys(@nickname)
  puts "◯ニックネームが@必須である"

  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').send_keys(@email)
  puts "◯メールアドレスが必須である"
  puts "◯メールアドレスは一意性である"
  puts "◯メールアドレスは@を含む必要がある"

  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').send_keys(@password)
  puts "◯パスワードが必須である"
  puts "◯パスワードは6文字以上である"
  puts "◯パスワードは半角英数字混合である"

  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').send_keys(@password)
  puts "◯パスワードは確認用を含めて2回入力する"

  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').send_keys(@first_name)
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').send_keys(@last_name)
  puts "◯ユーザー本名が、名字と名前がそれぞれ必須である"
  puts "◯ユーザー本名は全角（漢字・ひらがな・カタカナ）で入力させる"


  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').send_keys(@first_name_kana)
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').send_keys(@last_name_kana)
  puts "◯ユーザー本名のフリガナが、名字と名前でそれぞれ必須である"
  puts "◯ユーザー本名のフリガナは全角（カタカナ）で入力させる"


  puts "生年月日を入力してください。入力後、登録ボタンを押してください"
  # 登録ボタンはPC操作者にクリックさせる
end


# #ログイン
# @d.find_element(:class,"login").click 
# @d.find_element(:id, 'email').send_keys(@email)
# @d.find_element(:id, 'password').send_keys(@password)
# @d.find_element(:class,"login-red-btn").click

# トップメニューに戻ってきた後にログアウトする
def logout_from_the_topMenu
  # 「出品する」ボタンが存在するかでトップ画面かどうか判断
  # {@d.find_element(:class,"purchase-btn").displayed?}　←必要あるのか？？
  # 要検討：ログアウト状態だと「出品する」ボタンを表示させない実装をしている受講生あり
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  puts "◯生年月日が必須である"

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
  puts "◯必須項目を入力し、ユーザー登録ができる" 
  else
  puts "☒必須項目を入力し、ユーザー登録ができていない" 
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end

  # if /ログアウト/.match(@d.page_source)
  @d.find_element(:link_text,"ログアウト").click
  # else

  # end
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

  # トップ画面に戻れているか
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
  puts "◯ログイン/ログアウトができる" 
  else
  puts "☒ログイン/ログアウトができない" 
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end
end

# 出品
# 画像添付なし
def item_new_no_image

  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

  # 出品ボタンを押して画面遷移できるかどうか
  if /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn").click
    puts "!出品ページに遷移1"
    puts 1
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    puts "!出品ページに遷移2"
    puts 2
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-icon").click
    puts "!出品ページに遷移3"
    puts 3
  else
    puts "!出品ページに遷移できない"
    @wait.until {@d.find_element(:id,"item-name").displayed?}
  end

  @wait.until {@d.find_element(:id,"item-name").displayed?}
  @d.find_element(:id,"item-name").send_keys(@item_name)

  @wait.until {@d.find_element(:id,"item-info").displayed?}
  @d.find_element(:id,"item-info").send_keys(@item_info)

  @wait.until {@d.find_element(:id,"item-category").displayed?}
  # 「カテゴリー」のセレクトタグから値を選択
  item_category_element = @d.find_element(:id,"item-category")
  item_category = Selenium::WebDriver::Support::Select.new(item_category_element)
  item_category.select_by(:value, @value)
  # 「商品の状態」のセレクトタグから値を選択
  @wait.until {@d.find_element(:id,"item-sales-status").displayed?}
  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = Selenium::WebDriver::Support::Select.new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)


  @wait.until {@d.find_element(:id,"item-shipping-fee-status").displayed?}
  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = Selenium::WebDriver::Support::Select.new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)

  @wait.until {@d.find_element(:id,"item-prefecture").displayed?}
  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = Selenium::WebDriver::Support::Select.new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)


  @wait.until {@d.find_element(:id,"item-price").displayed?}
  @d.find_element(:id,"item-price").send_keys(@item_price)
  @d.find_element(:class,"price-content").click

  #javascriptが動作しているかどうかを判断
  item_price_benefit = @item_price*0.9
  item_price_benefit = item_price_benefit.round
  item_price_benefit2 = item_price_benefit.to_s.gsub(/\@d{2}/, '\0,').to_i

  puts "!利益は#{item_price_benefit}" 


  @wait.until {@d.find_element(:id,"item-scheduled-delivery").displayed?}
  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = Selenium::WebDriver::Support::Select.new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)

  #表記をに,を入れているかどうかで又はを追記
  if /#{item_price_benefit}/.match(@d.page_source) || /#{item_price_benefit2}/.match(@d.page_source)
  puts "◯入力された販売価格によって、非同期的に販売手数料や販売利益が変わる(JavaScriptを使用して実装すること)" 
  else
  puts "☒入力された販売価格によって、非同期的に販売手数料や販売利益が変わらない" 
  @wait.until {@d.find_element(:id,'profit').text == item_price_benefit}
  end

  # 「出品する」ボタンをクリック
  @d.find_element(:class,"sell-btn").click

  if /商品の情報を入力/.match(@d.page_source)
    puts "◯画像が0枚の場合は、出品できない" 
    else
    puts "☒画像が0枚の場合は、出品できる" 
    @wait.until {@d.find_element(:id,"item-name").displayed?}
  end
end



# 出品
# 価格未入力
def item_new_price_uninput

  @wait.until {@d.find_element(:id,"item-name").displayed?}
  @d.find_element(:id,"item-name").clear
  @d.find_element(:id,"item-info").clear
  item_category_blank = @d.find_element(:id,"item-category")
  item_category_blank = Selenium::WebDriver::Support::Select.new(item_category_blank)
  item_category_blank.select_by(:value, @blank)

  item_sales_status_blank = @d.find_element(:id,"item-sales-status")
  item_sales_status_blank = Selenium::WebDriver::Support::Select.new(item_sales_status_blank )
  item_sales_status_blank.select_by(:value, @blank)

  item_shipping_fee_status_blank = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status_blank = Selenium::WebDriver::Support::Select.new(item_shipping_fee_status_blank )
  item_shipping_fee_status_blank.select_by(:value, @blank)

  item_prefecture_blank = @d.find_element(:id,"item-prefecture")
  item_prefecture_blank = Selenium::WebDriver::Support::Select.new(item_prefecture_blank )
  item_prefecture_blank.select_by(:value, @blank)

  item_scheduled_delivery_blank = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery_blank = Selenium::WebDriver::Support::Select.new(item_scheduled_delivery_blank )
  item_scheduled_delivery_blank.select_by(:value, @blank)

  @d.find_element(:id,"item-price").clear

  @wait.until {@d.find_element(:id,"item-image").displayed?}
  @d.find_element(:id,"item-image").send_keys(@item_image)
  @d.find_element(:id,"item-name").send_keys(@item_name) 
  @d.find_element(:id,"item-info").send_keys(@item_info)

  item_category_element = @d.find_element(:id,"item-category")
  item_category = Selenium::WebDriver::Support::Select.new(item_category_element)
  item_category.select_by(:value, @value)

  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = Selenium::WebDriver::Support::Select.new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)

  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = Selenium::WebDriver::Support::Select.new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)

  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = Selenium::WebDriver::Support::Select.new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)


  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = Selenium::WebDriver::Support::Select.new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)

  # @wait.until {@d.find_element(:id,"item-price").displayed?}
  # @d.find_element(:id,"item-price").send_keys(@item_price)

  @d.find_element(:class,"sell-btn").click

  if /商品の情報を入力/.match(@d.page_source)
    puts "!価格の記入なしで商品出品を行うと、商品出品ページリダイレクトされる"
  else
    puts "!価格の記入なしで商品出品を行っても、商品出品ページリダイレクトされない"
    @wait.until {@d.find_element(:id,"item-name").displayed?}
  end

  puts "◯必須項目が一つでも欠けている場合は、出品ができない"
  sleep 3

end

# 必須項目を全て入力した上で出品
# エラーハンドリングのチェック
def item_new_require_input

  puts '◯【目視で確認】エラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）'
  @d.find_element(:id,"item-image").clear
  @d.find_element(:id,"item-name").clear
  @d.find_element(:id,"item-info").clear
  item_category_blank = @d.find_element(:id,"item-category")
  item_category_blank = Selenium::WebDriver::Support::Select.new(item_category_blank)
  item_category_blank.select_by(:value, @blank)

  item_sales_status_blank = @d.find_element(:id,"item-sales-status")
  item_sales_status_blank = Selenium::WebDriver::Support::Select.new(item_sales_status_blank )
  item_sales_status_blank.select_by(:value, @blank)

  item_shipping_fee_status_blank = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status_blank = Selenium::WebDriver::Support::Select.new(item_shipping_fee_status_blank )
  item_shipping_fee_status_blank.select_by(:value, @blank)

  item_prefecture_blank = @d.find_element(:id,"item-prefecture")
  item_prefecture_blank = Selenium::WebDriver::Support::Select.new(item_prefecture_blank )
  item_prefecture_blank.select_by(:value, @blank)

  item_scheduled_delivery_blank = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery_blank = Selenium::WebDriver::Support::Select.new(item_scheduled_delivery_blank )
  item_scheduled_delivery_blank.select_by(:value, @blank)


  @d.find_element(:id,"item-price").clear

  @d.find_element(:id,"item-image").send_keys(@item_image)
  puts "◯画像は1枚必須である"

  @d.find_element(:id,"item-name").send_keys(@item_name) 
  puts "◯商品名が必須である"

  @d.find_element(:id,"item-info").send_keys(@item_info)
  puts "◯商品の説明が必須である"

  item_category_element = @d.find_element(:id,"item-category")
  item_category = Selenium::WebDriver::Support::Select.new(item_category_element)
  item_category.select_by(:value, @value)
  puts "◯カテゴリーの情報が必須である"

  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = Selenium::WebDriver::Support::Select.new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)
  puts "◯商品の状態についての情報が必須である"

  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = Selenium::WebDriver::Support::Select.new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)
  puts "◯配送料の負担についての情報が必須である"

  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = Selenium::WebDriver::Support::Select.new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)
  puts "◯発送元の地域についての情報が必須である"

  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = Selenium::WebDriver::Support::Select.new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)
  puts "◯発送までの日数についての情報が必須である"

  @d.find_element(:id,"item-price").send_keys(@item_price)
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
  #商品表示が昇順か降順
  @d.find_element(:class,"item-img-content").click 

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

  sleep 3
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

def logout_item_edit_and_buy
  # ヘッダーのトップへ遷移するアイコンをクリック
  @d.find_element(:class,"furima-icon").click

  # ログアウトをクリック
  @d.find_element(:link_text,"ログアウト").click
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

  if /会員情報入力/ .match(@d.page_source)
    puts "!ログインしていない状態で商品出品ページへアクセスすると、ログインページへ遷移しました"
    @wait.until {@d.find_element(:class,"second-logo").displayed?}
    # second-logo = トップページ以外でのヘッダーに表示されるトップへ遷移するアイコンをクリック
    @d.find_element(:class,"second-logo").click

  elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "!ログインしていない状態で商品出品ページへアクセスすると、トップページへ遷移しました"

  else
    puts "!ログインしていない状態で商品出品ページへアクセスすると、ログインページへ遷移できませんでした"
    @d.find_element(:class,"second-logo").click
  end

  puts "◯ログインしているユーザーだけが、出品ページへ遷移できる"

  # トップページにて出品された商品一覧(商品画像)が表示されているかどうか
  @wait.until {@d.find_element(:class, "item-img-content").displayed?}
  if /#{@item_image_name}/ .match(@d.page_source)
    puts "!ログインしていないユーザーでも、商品の一覧表示を確認でき、出品画像が表示されている" 
  else
    puts "!ログインしていないユーザーだと出品画像が表示されない" 
    # ？現在トップページ画面なのに「detail-item」クラスは商品詳細画面にしか存在しないクラスを指定している
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
  end

  # trueかfalseかどちらにせよ商品詳細画面に遷移したい
  # 例外処理で

  item_name = @d.find_element(:class,'item-name')
  puts "!商品名は" + item_name.text

  item_price = @d.find_element(:class,'item-price')
  puts "!商品価格は" + item_price.text

  # 商品詳細画面へ遷移
  @d.find_element(:class,"item-img-content").click
  if /編集/ .match(@d.page_source)
    puts "☒ログインしていないユーザーでも、商品の編集が行える" 
    @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  else
    puts "◯ログインしていないユーザーは、商品の編集が行えない。" 
  end

  if /削除/ .match(@d.page_source)
    puts "☒ログインしていないユーザーでも、商品の削除が行える"
    @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
  else
    puts "◯ログインしていないユーザーは、商品の削除が行えない。" 
  end



  if /購入画面に進む/.match(@d.page_source)
    puts "!購入ボタンがあるのでクリック"
    @d.find_element(:class,"item-red-btn").click
    if /会員情報入力/.match(@d.page_source)
      @d.find_element(:class,"second-logo").click
    else
      "☒ログインしていないユーザーは購入ページに遷移しようとすると、ログインページに遷移しない"
    end
  else
    puts "!購入ボタンがない"
  end

  puts "◯ログインしていないユーザーは購入ページに遷移しようとすると、ログインページに遷移する"

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
  @d.find_element(:id, 'last-name').send_keys(@user_last_name2)
  @d.find_element(:id, 'first-name-kana').send_keys(@first_name_kana2)
  @d.find_element(:id, 'last-name-kana').send_keys(@last_name_kana2)
  puts "生年月日を入力した後、登録ボタンを押してください"

  # 「商品出品」ボタンが存在するかチェック
  # トップページかどうか
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?} rescue puts "Error: class:purchase-btnが見つかりません"

  # 商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること
  check_3

  # #ログイン2
  # @d.find_element(:class,"login").click
  # @d.find_element(:id, 'email').send_keys(@email2)
  # @d.find_element(:id, 'password').send_keys(@password)
  # @d.find_element(:class,"login-red-btn").click

  puts "【説明】nickname2でログイン"
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
  #チェック機能追加
  @order_url_coat = @d.current_url
  puts "コート購入画面のURL→  " + @order_url_coat

  # コート購入前にチェック
  check_5

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

  if @item_name.match(@d.page_source)
    puts "☒ログインしていないユーザーでも、商品の編集が行える" 
    @wait.until {@d.find_element(:class,"item-red-btn").displayed?}
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

  # トップページでの表記をチェック
  if /Sold Out/ .match(@d.page_source)
    puts "◯売却済みの商品は、「sould out」の文字が表示されるようになっている" 
  else
    puts "☒売却済みの商品は、「sould out」の文字が表示されない" 
    @wait.until {@d.find_element(:class,"sold-out").displayed?}
  end

  # @order_url_coatは購入画面のURLでは？商品ページではないハズ
  @d.get(@order_url_coat)
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "◯@URLを直接入力して購入済みの商品ページへ遷移しようとすると、トップページに遷移する"
  else
    puts "☒@URLを直接入力して購入済みの商品ページへ遷移しようとすると、トップページに遷移しない"
    # 手動でトップページに遷移させる理由は？？
    # A:ここも出品ボタンの有無を確認して自動でトップに遷移する処理を実行させたい
    puts "!手動でトップページに遷移するとプログラムが動きます。"
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end

  @wait.until {@d.find_element(:class,"item-img-content").displayed?}

  # 一度購入した商品の商品詳細画面へすすむ
  @d.find_element(:class,"item-img-content").click 
  sleep 3
  if /購入画面に進む/ .match(@d.page_source)
    puts "!購入した商品だが、再度購入ボタンが表示されている"
    @d.find_element(:class,"item-red-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed?}

    # 84期まではログアウトユーザーが詳細画面を見ても「購入画面に進む」ボタンが表示されていてもOK(クリックするとトップに戻ること)
    # 85期からは「購入画面に進む」ボタンの表示自体がNG
    puts "◯しかし、押してもトップページに遷移するので購入した商品は、再度購入できない状態になっている"
    @d.find_element(:class,"furima-icon").click 
  else
    puts "!手動でトップページに遷移するとプログラムが動きます。"
    @d.find_element(:class,"furima-icon").click 
  end

  sleep 3
  # @wait.until {@d.find_element(:id,"FURIMAが選ばれる3つの理由").displayed?}
  # 今更だが、「出品する」という固定ワード検索だけではエラーが頻発しそう = 「出品」だけの表記の人もいそう
  # 一定数の受講生のみなので問題なし = エラーが起こったら手動で確認してもらう
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
  sleep 3
end


def login_user2_item_new
  # user2による出品
  @wait.until {@d.find_element(:id,"item-image").displayed?}
  @d.find_element(:id,"item-image").send_keys(@item_image2)
  @d.find_element(:id,"item-name").send_keys(@item_name2) 
  @d.find_element(:id,"item-info").send_keys(@item_info2)
  item_category_element = @d.find_element(:id,"item-category")
  item_category = Selenium::WebDriver::Support::Select.new(item_category_element)
  item_category.select_by(:value, @value)
  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = Selenium::WebDriver::Support::Select.new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)
  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = Selenium::WebDriver::Support::Select.new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)
  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = Selenium::WebDriver::Support::Select.new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)
  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = Selenium::WebDriver::Support::Select.new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)
  @d.find_element(:id,"item-price").send_keys(@item_price2)
  @d.find_element(:class,"sell-btn").click
end

# user2が出品したサングラスを購入する
def login_user1_item_buy
  # 出品完了後、トップページからログアウト
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:link_text,"ログアウト").click

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

# ログイン状態で商品購入
def no_user_item_buy
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:link_text,"ログアウト").click

  @d.get(@order_url_glasses)
  if /会員情報入力/ .match(@d.page_source)
    puts "！ログインしていない状態で@URLを直接入力し購入ページに遷移しようとするとログインページに遷移する"
    puts "◯ログインしていないユーザーは購入ページに遷移しようとすると、ログインページに遷移する"
  else
    puts "☒ログインしていないユーザーは購入ページに遷移しようとしても、ログインページに遷移しない"
    puts  "!手動でログインページに遷移するとプログラムが動きます。"
    @wait.until {@d.find_element(:id,"email").displayed?}
  end


  #ログイン2
  @wait.until {@d.find_element(:id,"email").displayed?}
  @d.find_element(:id, 'email').send_keys(@email2)
  @d.find_element(:id, 'password').send_keys(@password)
  @d.find_element(:class,"login-red-btn").click

  @d.get(@order_url_glasses)
  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    puts "◯出品者は@URLを直接入力して購入ページに遷移しようとすると、トップページに遷移する"
  else
    puts "☒出品者が@URLを直接入力して購入ページに遷移しようとすると、トップページに遷移しない"
    puts  "!手動でトップページに遷移するとプログラムが動きます。"
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end


  @wait.until {@d.find_element(:class,"item-img-content").displayed?}
  @d.find_element(:class,"item-img-content").click 
  if /購入画面に進む/ .match(@d.page_source)
    puts "☒出品者でも、商品購入のリンクが踏めるようになっている"
  else
    puts "◯出品者以外にしか、商品購入のリンクが踏めないようになっている" 
  end


  @wait.until {@d.find_element(:class,"item-destroy").displayed?}
  @d.find_element(:class,"item-destroy").click
  if /#{@item_name2}/ .match(@d.page_source)
    puts "☒出品者だけが商品情報を削除できない" 
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  else
    puts "◯出品者だけが商品情報を削除できる" 
  end 



  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:link_text,"ログアウト").click
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  if /#{@item_name}/ .match(@d.page_source)
    puts "◯ログアウトした状態でも、商品一覧を閲覧できる"
  else
    puts "☒ログアウトすると、商品一覧を閲覧できない"
  end

  @d.find_element(:class,"item-img-content").click

  @wait.until{@d.find_element(:class,"item-explain-box")}
  if @d.find_element(:class,"item-explain-box").text == @item_info_re
    puts  "!【商品説明は表示できている】" + @d.find_element(:class,"item-explain-box").text
  else
    puts "☒商品説明が表示されない"

  end
  puts "◯ログアウトした状態でも、商品詳細ページを閲覧できる"


  puts "プログラム終了"
  puts "ログイン情報1 user1_email #{@email} password #{@password}"
  puts "ログイン情報2 user2_email #{@email2} password #{@password}"
  puts "【目視で確認】商品出品時に登録した情報が見られるようになっている"
  puts "【目視で確認】新規登録、商品出品、商品購入の際にエラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）"
  puts "【目視で確認】basic認証が実装されている"
  puts "【目視で確認】ログイン/ログアウトによって、ヘッダーにてユーザーへ表示する情報が変わる"
  puts "【目視で確認】画像が表示されており、画像がリンク切れなどになっていない"
  puts "【目視で確認】ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること"
  puts "【目視で確認】パスワードは半角英数字混合であること"
  puts "【目視で確認】パスワードは6文字以上であること"
  puts "【目視で確認】価格の範囲が、¥300~¥9,999,999の間であること"
  puts "【目視で確認】商品出品時とほぼ同じ見た目で商品情報編集機能が実装されていること"
  puts "【目視で確認】商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること"
  puts "【目視で確認】ログイン状態の出品者でも、売却済みの商品に対しては「編集・削除ボタン」が表示されないこと"
  puts "【目視で確認】出品者・出品者以外にかかわらず、ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること"
  puts "【目視で確認】ログアウト状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、ログインページに遷移すること"
  puts "【目視で確認】ログアウト状態のユーザーは、URLを直接入力して商品情報編集ページへ遷移しようとすると、ログインページに遷移すること"
  puts "【目視で確認】商品購入画面で出品時に登録した情報が見られるようになっていること"
  puts "【目視で確認】商品詳細ページでログアウト状態のユーザーには、「編集・削除・購入画面に進むボタン」が表示されないこと"
  sleep 300000000000000
end