require "./main"


def check_1
  check_detail = {"チェック番号"=> 1 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態で、ヘッダーにログイン/新規登録ボタンが表示されること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
    # ログアウト状態でトップ画面にログインボタンとサインアップボタンが表示されているかチェック
    if @d.find_element(:class,"login").displayed?
      check_ele1 = @d.find_element(:class,"login").displayed? ? "○：ログアウト状態で、ヘッダーにログインボタンが表示されている\n" : "×：ログアウト状態では、ヘッダーにログインボタンが表示されない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end
    
    if @d.find_element(:class,"sign-up").displayed?
      check_ele2 = @d.find_element(:class,"sign-up").displayed? ? "◯：ログアウト状態で、ヘッダーに新規登録ボタンが表示されている\n" : "×：ログアウト状態では、ヘッダーに新規登録ボタンが表示されない\n"
      check_detail["チェック詳細"] << check_ele2
      check_flag += 1
    end
    
    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"
  
  ensure
    @check_log.push(check_detail)
  end
end


# ログイン状態
# ログイン状態では、ヘッダーにユーザーのニックネーム/ログアウトボタンが表示されること
def check_2
  check_detail = {"チェック番号"=> 2 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態では、ヘッダーにユーザーのニックネーム/ログアウトボタンが表示されること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
    # ログイン状態でトップ画面にユーザーのニックネームとログアウトボタンが表示されているか
    if @d.find_element(:class,"user-nickname").displayed?
      check_ele1 = @d.find_element(:class,"user-nickname").displayed? ? "○：ログイン状態で、ヘッダーにニックネームボタンが表示されている\n" : "×：ログアウト状態では、ヘッダーにユーザーのニックネームが表示されない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end

    if @d.find_element(:class,"logout").displayed?
      check_ele2 = @d.find_element(:class,"logout").displayed? ? "○：ログイン状態で、ヘッダーにログアウトボタンが表示されている\n" : "×：ログアウト状態では、ヘッダーにログアウトボタンが表示されない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

  ensure
    @check_log.push(check_detail)
  end
end

# 商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること
# 商品情報とは[商品名/商品画像/価格]の三つ
def check_3

  check_detail = {"チェック番号"=> 3 , "チェック合否"=> "" , "チェック内容"=> "商品購入ページでは、一覧や詳細ページで選択した商品の情報が出力されること" , "チェック詳細"=> ""}

  begin
    check_flag = 0
    # トップ画面でチェック
  
    # 一覧画面での商品情報を取得(新着順は最新の商品)
    @wait.until {@d.find_element(:class, "item-name").displayed?}
    top_item_name = @d.find_element(:class,"item-name").text rescue "Error：class：item-nameが見つかりません\n"
    top_item_img = @d.find_element(:class,"item-img").attribute("src") rescue "Error：class：item-imgが見つかりません\n"
    top_item_price = @d.find_element(:class,"item-price").find_element(:tag_name, "span").text rescue "Error：class：item-priceが見つかりません\n"
  
    # トップ画面の表示内容をチェック
    if top_item_name == @item_name
      check_detail["チェック詳細"] << "◯：トップ画面に商品名が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面に商品名が表示されていない\n"
      check_detail["チェック詳細"] << top_item_name
    end
  
    if top_item_img.include?(@item_image_name)
      check_detail["チェック詳細"] << "◯：トップ画面に商品画像が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面に商品画像が表示されていない\n"
      check_detail["チェック詳細"] << top_item_img
    end
  
    # 価格表示の親クラスから価格表示タグの表示内容を取得
    if top_item_price.include?(@item_price.to_s)
      check_detail["チェック詳細"] << "◯：トップ画面に商品価格が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面に商品価格が表示されていない\n"
      check_detail["チェック詳細"] << top_item_price
    end
  
    # 商品詳細画面へ遷移
    @d.find_element(:class,"item-img-content").click
  
    # 商品詳細画面での情報を取得
    @wait.until {@d.find_element(:class, "item-image").displayed?}
    show_item_name = @d.find_element(:class,"name").text rescue "Error：class：nameが見つかりません\n"
    show_item_img = @d.find_element(:class,"item-image").attribute("src") rescue "Error：class：item-imageが見つかりません\n"
    show_item_price = @d.find_element(:class,"item-price").text rescue "Error：class：item-priceが見つかりません\n"
  
    # 詳細画面の表示内容をチェック
    if show_item_name == @item_name
      check_detail["チェック詳細"] << "◯：詳細画面に商品名が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：詳細画面に商品名が表示されていない\n"
      check_detail["チェック詳細"] << show_item_name
    end
  
    if show_item_img.include?(@item_image_name)
      check_detail["チェック詳細"] << "◯：詳細画面に商品画像が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：詳細画面に商品画像が表示されていない\n"
      check_detail["チェック詳細"] << show_item_img
    end
  
    if show_item_price.include?(@item_price.to_s)
      check_detail["チェック詳細"] << "◯：詳細画面に商品価格が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：詳細画面に商品価格が表示されていない\n"
      check_detail["チェック詳細"] << show_item_price
    end
  
    # 商品購入画面へ遷移
    @d.find_element(:class,"item-red-btn").click
  
    # 商品購入画面での情報を取得
    @wait.until {@d.find_element(:class, "buy-item-img").displayed?}
    #まだクラス名が確定していない
    purchase_item_name = @d.find_element(:class,"item_name").text rescue "Error：class：item_nameが見つかりません\n"
    purchase_item_img = @d.find_element(:class,"buy-item-img").attribute("src") rescue "Error：class：buy-item-imgが見つかりません\n"
    purchase_item_price = @d.find_element(:class,"item-payment-price").text rescue "Error：class：item-payment-priceが見つかりません\n"
  
    # 購入画面の表示内容をチェック
    if purchase_item_name == @item_name
      check_detail["チェック詳細"] << "◯：購入画面に商品名が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：購入画面に商品名が表示されていない\n"
      check_detail["チェック詳細"] << purchase_item_name
    end
  
    if purchase_item_img.include?(@item_image_name)
      check_detail["チェック詳細"] << "◯：購入画面に商品画像が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：購入画面に商品画像が表示されていない\n"
      check_detail["チェック詳細"] << purchase_item_img
    end
  
    if purchase_item_price.include?(@item_price.to_s)
      check_detail["チェック詳細"] << "◯：購入画面に商品価格が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：購入画面に商品価格が表示されていない\n"
      check_detail["チェック詳細"] << purchase_item_price
    end
  
    check_detail["チェック合否"] = check_flag == 9 ? "◯" : "×"
  
    @check_log.push(check_detail)

    # トップ画面へ戻っておく
    @d.get(@url)
    # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end

# ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること
def check_4
  check_detail = {"チェック番号"=> 4 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    # ログアウト状態でトップ画面にログインボタンとサインアップボタンが表示されているかチェック
    # 直前で出品している商品は「サングラス」
    if @d.find_element(:class,"item-name").displayed?
      # 最新の商品名を取得
      latest_ele_name = @d.find_element(:class,"item-name").text
      # 最新の商品名が「サングラス」と同じか比較
      if latest_ele_name == @item_name2
        check_detail["チェック詳細"] << "○：ログアウト状態で、トップ画面で出品順に商品が並んでいる\n"
        check_flag += 1
      else
        check_detail["チェック詳細"] << "×：ログアウト状態で、トップ画面で出品順に商品が並んでいない\n"
      end
    else
      check_detail["チェック詳細"] << "×：ログアウト状態で、トップ画面にclass「item-name」が存在しない\n"
    end
    
    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"
  
  ensure
    @check_log.push(check_detail)
  end
end

# ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページに遷移すること
def check_5
  check_detail = {"チェック番号"=> 5 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページに遷移すること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    # 2つ目のウィンドウに切り替え
    @d.switch_to.window( @window2_id )
    @d.get(@url)

    # トップページ画面からスタート
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    # user_1でログイン
    login_user1

    # user_1がログイン状態で自分が出品したコートの購入画面に遷移(直接URL入力)
    @d.get(@order_url_coat)
    # アイコンが表示されるまで待機
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

    # 出品ボタンの有無でトップページに遷移したかを判断
    if @d.find_element(:class,"purchase-btn").displayed?
      check_detail["チェック詳細"] << "○：ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページに遷移する\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページ以外に遷移する\n"
      @d.get(@url)
    end

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    # ログアウトしておく
    @d.find_element(:link_text,"ログアウト").click
    @d.get(@url)
    @check_log.push(check_detail)
    # エラー発生有無に関係なく操作ウィンドウを元に戻す
    @d.switch_to.window( @window1_id )
  end
end

# check_6で活用する
def sign_up_user3

  # もしまだログイン状態であればログアウトしておく
  if @d.find_element(:class,"logout").displayed? then @d.find_element(:class,"logout").click end

  @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

  @d.find_element(:class,"sign-up").click
  @wait.until {@d.find_element(:id, 'nickname').displayed?}
  @d.find_element(:id, 'nickname').send_keys(@nickname3)
  @wait.until {@d.find_element(:id, 'email').displayed?}
  @d.find_element(:id, 'email').send_keys(@email3)
  @wait.until {@d.find_element(:id, 'password').displayed?}
  @d.find_element(:id, 'password').send_keys(@password)
  @wait.until {@d.find_element(:id, 'password-confirmation').displayed?}
  @d.find_element(:id, 'password-confirmation').send_keys(@password)
  @wait.until {@d.find_element(:id, 'first-name').displayed?}
  @d.find_element(:id, 'first-name').send_keys(@first_name3)
  @wait.until {@d.find_element(:id, 'last-name').displayed?}
  @d.find_element(:id, 'last-name').send_keys(@last_name3)
  @wait.until {@d.find_element(:id, 'first-name-kana').displayed?}
  @d.find_element(:id, 'first-name-kana').send_keys(@first_name_kana3)
  @wait.until {@d.find_element(:id, 'last-name-kana').displayed?}
  @d.find_element(:id, 'last-name-kana').send_keys(@last_name_kana3)

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


# ログイン状態の出品者以外のユーザーが、URLを直接入力して売却済み商品の商品購入ページへ遷移しようとすると、トップページに遷移すること
def check_6
  check_detail = {"チェック番号"=> 6 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品購入ページへ遷移しようとすると、トップページに遷移すること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    # 2つ目のウィンドウに切り替え
    @d.switch_to.window( @window2_id )
    @d.get(@url)


    # トップページ画面からスタート
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    #user3でサインアップ
    sign_up_user3

    # user3がログイン状態で他人が出品したコートの購入画面に遷移(直接URL入力)
    @d.get(@order_url_coat)
    # アイコンが表示されるまで待機
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

    # 出品ボタンの有無でトップページに遷移したかを判断
    if @d.find_element(:class,"purchase-btn").displayed?
      check_detail["チェック詳細"] << "○：ログイン状態の出品者以外のユーザーが、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページに遷移する\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン状態の出品者以外のユーザーが、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページ以外に遷移する\n"
      @d.get(@url)
    end

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    # ログアウトしておく
    @d.find_element(:class,"logout").click
    @d.get(@url)
    @check_log.push(check_detail)
    # エラー発生有無に関係なく操作ウィンドウを元に戻す
    @d.switch_to.window( @window1_id )
  end
end


def test_method
  @d.switch_to.window( @window2_id )
  @d.get "http://yahoo.com"
  sleep 10
  @d.get "https://www.google.com/?hl=ja"
  sleep 10
  @d.switch_to.window( @window1_id )
  @d.get "https://www.google.com/?hl=ja"
end