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

  puts "1-001◯必須項目が一つでも欠けている場合は、ユーザー登録ができない"

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
  puts "1-002◯ニックネームが必須である"

  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').send_keys(@email)
  puts "1-003◯メールアドレスが必須である"
  puts "1-004◯メールアドレスは一意性である"
  puts "1-005◯メールアドレスは@を含む必要がある"

  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').send_keys(@password)
  puts "1-006◯パスワードが必須である"
  #注意ここは追加で実装するか目視で確認にする。
  puts "◯パスワードは6文字以上である"
  puts "◯パスワードは半角英数字混合である"

  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').send_keys(@password)
  #注意ここは追加で実装するか目視で確認にする。
  puts "1-007◯パスワードは確認用を含めて2回入力する"

  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').send_keys(@first_name)
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').send_keys(@last_name)
  puts "1-008◯ユーザー本名が、名字と名前がそれぞれ必須である"
  puts "1-009◯ユーザー本名は全角（漢字・ひらがな・カタカナ）で入力させる"


  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').send_keys(@first_name_kana)
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').send_keys(@last_name_kana)
  puts "1-010◯ユーザー本名のフリガナが、名字と名前でそれぞれ必須である"
  puts "1-011◯ユーザー本名のフリガナは全角（カタカナ）で入力させる"


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
end


# トップメニューに戻ってきた後にログアウトする
def logout_from_the_topMenu
  # 「出品する」ボタンが存在するかでトップ画面かどうか判断
  # {@d.find_element(:class,"purchase-btn").displayed?}　←必要あるのか？？
  # 要検討：ログアウト状態だと「出品する」ボタンを表示させない実装をしている受講生あり
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  puts "1-012◯生年月日が必須である"

  if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
  puts "1-013◯必須項目を入力し、ユーザー登録ができる" 
  else
  puts "1-013☓必須項目を入力し、ユーザー登録ができていない" 
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  end

  # if /ログアウト/.match(@d.page_source)
  @d.find_element(:class,"logout").click
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
  puts "1-014◯ログイン/ログアウトができる" 
  else
  puts "1-014☓ログイン/ログアウトができない" 
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
    # "!出品ページに遷移1"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    #"!出品ページに遷移2"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-icon").click
    #"!出品ページに遷移3"
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
  item_category = select_new(item_category_element)
  item_category.select_by(:value, @value)
  # 「商品の状態」のセレクトタグから値を選択
  @wait.until {@d.find_element(:id,"item-sales-status").displayed?}
  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = select_new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)


  @wait.until {@d.find_element(:id,"item-shipping-fee-status").displayed?}
  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = select_new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)

  @wait.until {@d.find_element(:id,"item-prefecture").displayed?}
  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = select_new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)


  @wait.until {@d.find_element(:id,"item-price").displayed?}
  @d.find_element(:id,"item-price").send_keys(@item_price)
  @d.find_element(:class,"price-content").click

  #javascriptが動作しているかどうかを判断
  item_price_benefit = @item_price*0.9
  item_price_benefit = item_price_benefit.round
  item_price_benefit2 = item_price_benefit.to_s.gsub(/\@d{2}/, '\0,').to_i

  #puts "!利益は#{item_price_benefit}" 


  @wait.until {@d.find_element(:id,"item-scheduled-delivery").displayed?}
  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = select_new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)

  #表記をに,を入れているかどうかで又はを追記
  if /#{item_price_benefit}/.match(@d.page_source) || /#{item_price_benefit2}/.match(@d.page_source)
  puts "◯2-001入力された販売価格によって、非同期的に販売手数料や販売利益が変わる(JavaScriptを使用して実装すること)" 
  else
  puts "☓2-001入力された販売価格によって、非同期的に販売手数料や販売利益が変わらない" 
  @wait.until {@d.find_element(:id,'profit').text == item_price_benefit}
  end

  # 「出品する」ボタンをクリック
  @d.find_element(:class,"sell-btn").click

  if /商品の情報を入力/.match(@d.page_source)
    puts "◯2-002商品画像を1枚つけることが必須であること(ActiveStorageを使用すること)" 
    else
    puts "☓2-002商品画像を1枚つけることが必須でない" 
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

  @d.find_element(:id,"item-price").clear

  @wait.until {@d.find_element(:id,"item-image").displayed?}
  @d.find_element(:id,"item-image").send_keys(@item_image)
  @d.find_element(:id,"item-name").send_keys(@item_name) 
  @d.find_element(:id,"item-info").send_keys(@item_info)

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

  # @wait.until {@d.find_element(:id,"item-price").displayed?}
  # @d.find_element(:id,"item-price").send_keys(@item_price)

  @d.find_element(:class,"sell-btn").click

  if /商品の情報を入力/.match(@d.page_source)
    # "!価格の記入なしで商品出品を行うと、商品出品ページリダイレクトされる"
    puts "◯2-003必須項目が一つでも欠けている場合は、出品ができない"
  else
   #"!価格の記入なしで商品出品を行っても、商品出品ページリダイレクトされない"
   puts "☓2-003必須項目が一つでも欠けている場合でも出品ができる。"
    @wait.until {@d.find_element(:id,"item-name").displayed?}
  end


end

# 必須項目を全て入力した上で出品
# エラーハンドリングのチェック
def item_new_require_input

  @d.find_element(:id,"item-image").clear
  @d.find_element(:id,"item-name").clear
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


  @d.find_element(:id,"item-price").clear

  @d.find_element(:id,"item-image").send_keys(@item_image)

  @d.find_element(:id,"item-name").send_keys(@item_name) 
  puts "◯2-004商品名が必須である"

  @d.find_element(:id,"item-info").send_keys(@item_info)
  puts "◯2-005商品の説明が必須である"

  item_category_element = @d.find_element(:id,"item-category")
  item_category = select_new(item_category_element)
  item_category.select_by(:value, @value)
  puts "◯2-006カテゴリーの情報が必須である"

  item_sales_status_element = @d.find_element(:id,"item-sales-status")
  item_sales_status = select_new(item_sales_status_element)
  item_sales_status.select_by(:value, @value)
  puts "◯2-007商品の状態についての情報が必須である"

  item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")
  item_shipping_fee_status = select_new(item_shipping_fee_status_element)
  item_shipping_fee_status.select_by(:value, @value)
  puts "◯2-008配送料の負担についての情報が必須である"

  item_prefecture_element = @d.find_element(:id,"item-prefecture")
  item_prefecture = select_new(item_prefecture_element)
  item_prefecture.select_by(:value, @value)
  puts "◯2-009発送元の地域についての情報が必須である"

  item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery")
  item_scheduled_delivery = select_new(item_scheduled_delivery_element)
  item_scheduled_delivery.select_by(:value, @value)
  puts "◯2-010発送までの日数についての情報が必須である"

  @d.find_element(:id,"item-price").send_keys(@item_price)
  puts "◯2-011価格についての情報が必須である"
  
  puts "#未実装◯販売価格は半角数字のみ入力可能"

  @d.find_element(:class,"sell-btn").click

  puts "◯2-004必須項目を入力した上で出品ができる"
  

end

# ログイン状態
# トップページ　→　商品詳細画面(自分で出品した商品)
# 商品編集(エラーハンドリング)
def item_edit
  #商品表示が昇順か降順
  @d.find_element(:class,"item-img-content").click 

  # 商品詳細画面
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

  
  #「商品の説明」項目に新しい値を入力して再度出品してみる
  @d.find_element(:id,"item-info").clear
  @d.find_element(:id,"item-info").send_keys(@item_info_re)
  @d.find_element(:class,"sell-btn").click

  # 稀に編集画面に遷移した際に値を保持していない実装をしている受講生がいるため、商品詳細画面に遷移できているかあぶり出すチェック項目
  if /#{@item_info_re}/.match(@d.page_source)
    puts "◯5-001商品名やカテゴリーの情報など、すでに登録されている商品情報は編集画面を開いた時点で表示される"
  elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
    @d.find_element(:class,"item-img-content").click
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
    puts "◯5-001商品名やカテゴリーの情報など、すでに登録されている商品情報は編集画面を開いた時点で表示される"
  else
    puts "☓5-001商品説明が表示されないまたは、商品名やカテゴリーの情報など、すでに登録されている商品情報は編集画面を開いた時点で表示されない" 
    # 必要な情報が入力された状態で編集確定されると商品詳細画面に戻ってくるため、detail-itemが表示されるが正解
    @wait.until {@d.find_element(:class,"detail-item").displayed?}
  end

  puts "◯5-002商品情報（商品画像・商品名・商品の状態など）を変更できる"
  puts "◯5-003何も編集せずに更新をしても画像無しの商品にならない"
 
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
    # puts "!出品ページに遷移1"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    # puts "!出品ページに遷移2"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-icon").click
    # puts "!出品ページに遷移3"
  else
    puts "!出品ページに遷移できない"
  end

  # ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること
  check_9

  # check_3でチェックされているためコメントアウト
  # トップページにて出品された商品一覧(商品画像)が表示されているかどうか
  # @wait.until {@d.find_element(:class, "item-img-content").displayed?}
  # if /#{@item_image_name}/ .match(@d.page_source)
  #   puts "!ログアウト状態で、トップ画面にて商品の一覧表示を確認でき、出品画像が表示されている" 
  # else
  #   puts "!ログアウト状態だとトップ画面にて出品画像が表示されない"
  # end

  # item_name = @d.find_element(:class,'item-name')
  # puts "!商品名は" + item_name.text

  # item_price = @d.find_element(:class,'item-price')
  # puts "!商品価格は" + item_price.text

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

  # 「商品出品」ボタンが存在するかチェック
  # トップページかどうか
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?} rescue puts "Error: class:purchase-btnが見つかりません"

  # ログイン状態の出品者以外のユーザーのみ、「購入画面に進むボタン」が表示されること
  check_12
  # 商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること
  check_3

end

def login_user2_item_buy
  @wait.until {@d.find_element(:class,"item-img-content").displayed?}

  # 自分が出品していない商品の詳細画面へ遷移
  @d.find_element(:class,"item-img-content").click
  

  puts "◯4-001ログイン状態の出品者のみ、「編集・削除ボタン」が表示されること"
  puts "◯5-004ログイン状態の出品者だけが商品情報編集ページに遷移できること"

  @wait.until {@d.find_element(:class, "item-red-btn").displayed?}
  #購入ボタンを押して購入ページへ遷移する
  @d.find_element(:class,"item-red-btn").click

  # 購入画面のURLをputsする理由とは？ = 途中でエラーが起こった場合に踏むURL保持しておくため
  @order_url_coat = @d.current_url
  puts "!コート購入画面のURL→  " + @order_url_coat

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
    #puts "!カード番号が入力されていない無い場合は、決済できない" 
    puts "◯7-001クレジットカード情報は必須であり、正しいクレジットカードの情報で無いときは決済できない"
  else
    puts "!カード番号が入力されていない無い場合でも、決済できる" 
    puts "☓7-001クレジットカード情報は必須でなく、正しいクレジットカードの情報で無いときでも決済できる"
    @wait.until {@d.find_element(:class,"sold-out").displayed?}
  end

  



  @wait.until {@d.find_element(:id, 'card-number').displayed?}
  @d.find_element(:id, 'card-number').send_keys(@card_number)
  @wait.until {@d.find_element(:id, 'card-exp-month').displayed?}
  @d.find_element(:id, 'card-exp-month').send_keys(@card_exp_month)
  @wait.until {@d.find_element(:id, 'card-exp-year').displayed?}
  @d.find_element(:id, 'card-exp-year').send_keys(@card_exp_year)
  @wait.until {@d.find_element(:id, 'card-cvc').displayed?}
  @d.find_element(:id, 'card-cvc').send_keys(@card_cvc)
  puts "◯7-002購入時、クレジットカードの情報を都度入力できる"
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
  puts "◯7-003購入時、配送先の住所情報も都度入力できる"

  #処理が早くて購入ができなかったため購入ボタンを押す前にsleepを記述している
  sleep 8
  @d.find_element(:class,"buy-red-btn").click


  @wait.until {@d.find_element(:class,"furima-icon").displayed?}
  puts "◯7-004クレジットカード決済ができる"
  puts "◯7-005配送先の情報として、郵便番号・都道府県・市区町村・番地・電話番号が必須であること"
  puts "【未実装】郵便番号にはハイフンが必要であること（123-4567となる）"
  puts "【未実装】電話番号にはハイフンは不要で、11桁以内である"
  puts "◯7-006購入が完了したら、トップページまたは購入完了ページに遷移する"
  puts "◯7-008必要な情報を適切に入力すると、商品の購入ができる"
  # もし購入完了後に購入完了ページへ遷移するのであればトップページへ遷移させる処理が必要では？
  # A：後々トップページへ遷移する処理を挟みたい
end

# 購入後の商品状態や表示方法をチェック
def login_user2_after_purchase_check1

  login_any_user(@email2, @password)

  # トップページでの表記をチェック
  if /Sold Out/ .match(@d.page_source)
    puts "◯3-001売却済みの商品は、「sold out」の文字が表示されるようになっている" 
  else
    puts "☓3-001売却済みの商品は、「sold out」の文字が表示されない" 
    @wait.until {@d.find_element(:class,"sold-out").displayed?}
  end


  @d.get(@order_url_coat)
  # アイコンが表示されるまで待機
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }


  @d.get(@url)

  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

  @wait.until {@d.find_element(:class,"item-img-content").displayed?}

  # 一度購入した商品の商品詳細画面へすすむ
  # @d.find_element(:class,"item-img-content").click
  
  # @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  # if /購入画面に進む/ .match(@d.page_source)
  #   puts "☓購入した商品だが、再度購入ボタンが表示されている"
  #   @d.find_element(:class,"item-red-btn").click
  #   @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  #   # 遷移先の画面に出品ボタンの有無でトップページに遷移したかを判断
  #   if @d.find_element(:class,"purchase-btn").displayed?
  #     # puts "◯しかし、押してもトップページに遷移するので購入した商品は、再度購入できない状態になっている"
  #   else
  #     puts "×「購入ボタン」を押すとトップページ以外の画面に遷移する状態になっている"
  #     @d.get(@url)
  #   end
  #   # 84期まではログアウトユーザーが詳細画面を見ても「購入画面に進む」ボタンが表示されていてもOK(クリックするとトップに戻ること)
  #   # 85期からは「購入画面に進む」ボタンの表示自体がNG

  # else
  #   # puts "!一度購入した商品には再度購入ボタンが表示されない"

  #   @d.get(@url)
  # end

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  
  if /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn").click
    # puts "!出品ページに遷移1"
  elsif /出品する/ .match(@d.page_source)
    @d.find_element(:class,"purchase-btn-text").click
    # puts "!出品ページに遷移2"
  elsif /出品する/ .match(@d.page_source)
      @d.find_element(:class,"purchase-btn-icon").click
      # puts "!出品ページに遷移3"
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
  puts "サングラス購入画面のURL→  "+ @order_url_glasses
  @d.get(@url)
end

# ログイン状態で商品購入
def no_user_item_buy
  @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
  @d.find_element(:class,"logout").click

  @d.get(@order_url_glasses)
  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  if /会員情報入力/ .match(@d.page_source)
    # ログインページへ遷移するのが正解
    puts "◯7-007ログアウト状態のユーザーは、URLを直接入力して商品購入ページに遷移しようとすると、商品の販売状況に関わらずログインページに遷移すること"
  else
    # ログインページに遷移しなかったらログインページへ遷移させる
    puts "☓7-007ログアウト状態のユーザーは、URLを直接入力して商品購入ページに遷移しようとすると、商品の販売状況に関わらずログインページに遷移しない"
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



  @wait.until {@d.find_element(:class,"item-img-content").displayed?}
  @d.find_element(:class,"item-img-content").click

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}


  # 商品削除ボタン
  @wait.until {@d.find_element(:class,"item-destroy").displayed?}
  @d.find_element(:class,"item-destroy").click

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

  # 最新出品商品名 = 「サングラス」以外の商品名
  latest_item_name = @d.find_element(:class,"item-name").text
  if latest_item_name == @item_name2
    puts "☓6-001出品者が商品詳細ページで削除ボタンを押しても削除できない"
  else
    puts "◯6-001出品者だけが商品情報を削除できる"
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
      puts "◯3-002ログアウトした状態でも、商品一覧を閲覧できる"
    else
      puts "☓3-002ログアウトすると、商品一覧を閲覧できない"
      puts "☓伴ってログアウトした際の商品詳細画面での商品説明の有無は確認できない"
    end
  else
    puts "☓3-002ログアウトすると、商品一覧を閲覧できない"
    puts "☓伴ってログアウトした際の商品詳細画面での商品説明の有無は確認できない"
  end

  # トップページに商品画像が存在していたら商品説明のチェックを行う
  if @d.find_element(:class,"item-img-content").displayed?
    @d.find_element(:class,"item-img-content").click

    # 商品説明の情報の有無チェック
    # チェック3により不要？
    # @wait.until{@d.find_element(:class,"item-explain-box")}
    # if @d.find_element(:class,"item-explain-box").text == @item_info_re
    #   puts  "!【商品説明は表示できている】" + @d.find_element(:class,"item-explain-box").text
    # else
    #   puts "☓商品説明が表示されない"
    # end
    
  end

  #昇順で出品が表示されないと動作しない仕様のため
  puts "◯ログアウトした状態でも、商品詳細ページを閲覧できる"
  puts "◯3-001上から、出品された日時が新しい順に表示されること"

  puts "プログラム終了"
  puts "ログイン情報1 user1_email #{@email} password #{@password}"
  puts "ログイン情報2 user2_email #{@email2} password #{@password}\n\n\n"
  #目視で確認
  puts "出品した商品の一覧表示ができている"
  puts "売却済みの商品は、画像上に「sold out」の文字が表示されるようになっていること"
  puts "ログアウト状態のユーザーでも、商品一覧表示ページを見ることができること"
  puts "画像が表示されており、画像がリンク切れなどになっていないこと（Herokuの仕様による画像のリンク切れは、
  要件未達に含まれない。Heroku上では一定時間経過すると画像が消える。）"

  # puts "【目視で確認】商品出品時に登録した情報が見られるようになっている"
  # puts "【目視で確認】新規登録、商品出品、商品購入の際にエラーハンドリングができていること（適切では無い値が入力された場合、情報は保存されず、エラーメッセージを出力させる）"
  # puts "【目視で確認】basic認証が実装されている"
  # puts "【目視で確認】ログイン/ログアウトによって、ヘッダーにてユーザーへ表示する情報が変わる"
  # puts "【目視で確認】画像が表示されており、画像がリンク切れなどになっていない"
  # puts "【目視で確認】ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること"
  # puts "【目視で確認】パスワードは半角英数字混合であること"
  # puts "【目視で確認】パスワードは6文字以上であること"
  # puts "【目視で確認】価格の範囲が、¥300~¥9,999,999の間であること"
  # puts "【目視で確認】商品出品時とほぼ同じ見た目で商品情報編集機能が実装されていること"
  # puts "【目視で確認】商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること"
  # puts "【目視で確認】ログイン状態の出品者でも、売却済みの商品に対しては「編集・削除ボタン」が表示されないこと"
  # puts "【目視で確認】出品者・出品者以外にかかわらず、ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること"
  # puts "【目視で確認】ログアウト状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、ログインページに遷移すること"
  # puts "【目視で確認】ログアウト状態のユーザーは、URLを直接入力して商品情報編集ページへ遷移しようとすると、ログインページに遷移すること"
  # puts "【目視で確認】商品購入画面で出品時に登録した情報が見られるようになっていること"
  # puts "【目視で確認】商品詳細ページでログアウト状態のユーザーには、「編集・削除・購入画面に進むボタン」が表示されないこと\n"
end