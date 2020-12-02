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
      check_detail["チェック詳細"] << "×：ログアウト状態で、トップ画面で出品順に商品が並んでいない\n"
    end
    
    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"
  
  ensure
    @check_log.push(check_detail)
  end
end
