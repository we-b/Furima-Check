require "./main"

# ログアウト状態でトップ画面にログインボタンとサインアップボタンが表示されているかチェック
def check_1
  check_detail = {"チェック番号"=> 1 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態で、ヘッダーにログイン/新規登録ボタンが表示されること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
    display_flag = @d.find_element(:class,"login").displayed? rescue false
    if display_flag
      check_ele1 = @d.find_element(:class,"login").displayed? ? "○：ログアウト状態で、ヘッダーにログインボタンが表示されている\n" : "×：ログアウト状態では、ヘッダーにログインボタンが表示されない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end
    
    display_flag = @d.find_element(:class,"sign-up").displayed? rescue false
    if display_flag
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

    display_flag = @d.find_element(:class,"user-nickname").displayed? rescue false
    # ログイン状態でトップ画面にユーザーのニックネームとログアウトボタンが表示されているか
    if display_flag
      check_ele1 = @d.find_element(:class,"user-nickname").displayed? ? "○：ログイン状態で、ヘッダーにニックネームボタンが表示されている\n" : "×：ログアウト状態では、ヘッダーにユーザーのニックネームが表示されない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end

    display_flag = @d.find_element(:class,"logout").displayed? rescue false
    if display_flag
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
    @wait.until {@d.find_element(:class, "item-box-img").displayed?}
    show_item_name = @d.find_element(:class,"name").text rescue "Error：class：nameが見つかりません\n"
    show_item_img = @d.find_element(:class,"item-box-img").attribute("src") rescue "Error：class：item-box-imgが見つかりません\n"
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
    purchase_item_name = @d.find_element(:class,"buy-item-text").text rescue "Error：class：buy-item-textが見つかりません\n"
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
  
    # トップ画面へ戻っておく
    @d.get(@url)
    # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end

# ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること
# サングラス　→　コートの順に出品されているかチェック
def check_4
  check_detail = {"チェック番号"=> 4 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態で、トップ画面の上から、出品された日時が新しい順に表示されること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    display_flag = @d.find_element(:class,"item-name").displayed? rescue false
    # ログアウト状態でトップ画面にログインボタンとサインアップボタンが表示されているかチェック
    # 直前で出品している商品は「サングラス」
    if display_flag
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
    login_any_user(@email, @password)

    # user_1がログイン状態で自分が出品したコートの購入画面に遷移(直接URL入力)
    @d.get(@order_url_coat)
    # アイコンが表示されるまで待機
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }

    display_flag = @d.find_element(:class,"purchase-btn").displayed? rescue false
    # 出品ボタンの有無でトップページに遷移したかを判断
    if display_flag
      check_detail["チェック詳細"] << "○：ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページに遷移する\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン状態の出品者が、URLを直接入力して自身の出品した商品購入ページに遷移しようとすると、トップページ以外に遷移する\n"
      @d.get(@url)
    end

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    # ログアウトしておく
    @d.find_element(:class,"logout").click
    @d.get(@url)
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    @check_log.push(check_detail)
    # エラー発生有無に関係なく操作ウィンドウを元に戻す
    @d.switch_to.window( @window1_id )
  end
end

# check_6で活用する
def sign_up_user3

  display_flag = @d.find_element(:class,"logout").displayed? rescue false
  # もしまだログイン状態であればログアウトしておく
  if display_flag then @d.find_element(:class,"logout").click end

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

    display_flag = @d.find_element(:class,"purchase-btn").displayed? rescue false
    # 出品ボタンの有無でトップページに遷移したかを判断
    if display_flag
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

# 商品出品時とほぼ同じ見た目で商品情報編集機能が実装されていること
def check_7
  check_detail = {"チェック番号"=> 7 , "チェック合否"=> "" , "チェック内容"=> "商品出品時とほぼ同じ見た目で商品情報編集機能が実装されていること" , "チェック詳細"=> ""}
  check_flag = 0
  begin
    @wait.until {@d.find_element(:class,"sell-btn").displayed?}

    # 商品の入力項目のチェック用配列
    item_input_data = {}
    item_input_data["商品画像"] = @d.find_element(:id,"item-image") rescue "×：商品画像(class名：item-image)が存在しませんでした\n"
    item_input_data["商品名"] = @d.find_element(:id,"item-name") rescue "×：商品名(class名：item-name)が存在しませんでした\n"
    item_input_data["商品の説明"] = @d.find_element(:id,"item-info") rescue "×：商品の説明(class名：item-info)が存在しませんでした\n"
    item_input_data["商品カテゴリー"] = @d.find_element(:id,"item-category") rescue "×：商品カテゴリー(class名：item-category)が存在しませんでした\n"
    item_input_data["商品の状態"] = @d.find_element(:id,"item-sales-status") rescue "×：商品の状態(class名：item-sales-status)が存在しませんでした\n"
    item_input_data["配送料の負担"] = @d.find_element(:id,"item-shipping-fee-status") rescue "×：配送料の負担(class名：item-shipping-fee-status)が存在しませんでした\n"
    item_input_data["発送元の地域"] = @d.find_element(:id,"item-prefecture") rescue "×：発送元の地域(class名：item-prefecture)が存在しませんでした\n"
    item_input_data["発送までの日数"] = @d.find_element(:id,"item-scheduled-delivery") rescue "×：発送までの日数(class名：item-scheduled-delivery)が存在しませんでした\n"
    item_input_data["商品価格"] = @d.find_element(:id,"item-price") rescue "×：商品価格(class名：item-name)が存在しませんでした\n"

    # 適切なタグではなかった場合のエラー文言作成メソッド
    def create_NG_result_status(check_name, tag, answer_tag)
      return "×：【#{check_name}】は存在するが、タグが<#{tag}>によって作成されているためNG 正解は<#{answer_tag}>タグでの作成が必要\n"
    end

    item_input_data.each{|key, value|
      # 内容が文字列かどうかチェック = 文字列だったらエラー判定
      if value.kind_of?(String)
        # エラー文言をそのまま詳細に追加
        check_detail["チェック詳細"] << value
      else
        # チェック項目に応じてチェック詳細文章を作成する
        case key
        when "商品画像"
          result = value.tag_name == "input" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "input") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "商品名"
          result = value.tag_name == "textarea" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "textarea") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "商品の説明"
          result = value.tag_name == "textarea" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "textarea") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "商品カテゴリー"
          result = value.tag_name == "select" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "select") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "商品の状態"
          result = value.tag_name == "select" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "select") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "配送料の負担"
          result = value.tag_name == "select" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "select") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "発送元の地域"
          result = value.tag_name == "select" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "select") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "発送までの日数"
          result = value.tag_name == "select" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "select") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        when "商品価格"
          result = value.tag_name == "input" ? "◯：【#{key}】は正常に表示されている\n" : create_NG_result_status(key, value.tag_name, "input") ;
          check_detail["チェック詳細"] << result
          check_flag += 1
        end
      end
    }

    check_detail["チェック合否"] = check_flag == 9 ? "◯" : "×"

  ensure
    @check_log.push(check_detail)
  end
end

# ログアウト状態のユーザーは、URLを直接入力して商品情報編集ページへ遷移しようとすると、ログインページに遷移すること
def check_8
  check_detail = {"チェック番号"=> 8 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態のユーザーは、URLを直接入力して商品情報編集ページへ遷移しようとすると、ログインページに遷移すること" , "チェック詳細"=> ""}
  check_flag = 0
  begin
    @wait.until {@d.find_element(:class,"sell-btn").displayed?}

    # 商品編集画面のURLを取得
    @edit_url_coat = @d.current_url

    # ウィンドウ切り替え
    @d.switch_to.window( @window2_id )
    
    @d.get(@url)
    # 他ユーザーでログイン中のためログアウト
    @d.find_element(:class,"logout").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false}

    # ログアウト状態でコート編集画面に直接遷移する
    @d.get(@edit_url_coat)

    # 編集画面に遷移した時も想定した判定基準を追加
    # 編集画面のロゴ画像にはクラス名が振られていないため
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    if /会員情報入力/ .match(@d.page_source)
      check_detail["チェック詳細"] << "◯：ログアウト状態のユーザーが、URLを直接入力して商品編集ページに遷移しようとすると、ログインページに遷移する\n"
      check_flag += 1
    elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
      check_detail["チェック詳細"] << "×：ログアウト状態のユーザーが、URLを直接入力して商品編集ページに遷移しようとすると、トップページに遷移してしまう\n"
    else
      check_detail["チェック詳細"] << "×：ログアウト状態のユーザーが、URLを直接入力して商品編集ページに遷移しようとすると、ログインページでもトップページでもないページに遷移してしまう\n"
    end

    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    @d.get(@url)
    @check_log.push(check_detail)
    # エラー発生有無に関係なく操作ウィンドウを元に戻す
    @d.switch_to.window( @window1_id )
    
  end

end

# ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること
def check_9
  check_detail = {"チェック番号"=> 9 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態のユーザーは、商品出品ページへ遷移しようとすると、ログインページへ遷移すること" , "チェック詳細"=> ""}
  check_flag = 0
  begin
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    if /会員情報入力/ .match(@d.page_source)
      check_detail["チェック詳細"] << "◯：!ログアウト状態で商品出品ページへアクセスすると、ログインページへ遷移しました\n"
      check_flag += 1
    elsif /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
      check_detail["チェック詳細"] << "×：!ログアウト状態で商品出品ページへアクセスすると、トップページへ遷移しました\n"
    else
      check_detail["チェック詳細"] << "×：!ログアウト状態で商品出品ページへアクセスすると、ログインページ、トップページ以外の画面へ遷移しました\n"
    end

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
    @d.get(@url)

    @check_log.push(check_detail)
  end
end

# 出品者でも、売却済みの商品に対しては「編集・削除ボタン」が表示されないこと
def check_10
  check_detail = {"チェック番号"=> 10 , "チェック合否"=> "" , "チェック内容"=> "出品者でも、売却済みの商品に対しては「編集・削除ボタン」が表示されないこと" , "チェック詳細"=> ""}
  check_flag = 0
  begin
    # 2つ目のウィンドウに切り替え
    @d.switch_to.window( @window2_id )
    
    @d.get(@url)


    # トップページ画面からスタート
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    # コートを出品したuser1でログイン
    login_any_user(@email, @password)
    # 最新商品 =
    items = @d.find_elements(:class,"item-name")
    items.each{|item|
      #直前で購入した「コート」の詳細画面へ遷移
      if item.text == @item_name then item.click end
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
      break
    }

    # 編集ボタンの有無
    if /編集/.match(@d.page_source)
      check_detail["チェック詳細"] << "×：出品者が売却済みの商品の商品詳細画面へいくと、「編集」のリンクが表示されている\n"
    else
      check_detail["チェック詳細"] << "◯：出品者が売却済みの商品の商品詳細画面へいくと、「編集」のリンクが表示されていない\n"
      check_flag += 1
    end

    # 削除ボタンの有無
    if /削除/.match(@d.page_source)
      check_detail["チェック詳細"] << "×：出品者が売却済みの商品の商品詳細画面へいくと、「削除」のリンクが表示されている\n"
    else
      check_detail["チェック詳細"] << "◯：出品者が売却済みの商品の商品詳細画面へいくと、「削除」のリンクが表示されていない\n"
      check_flag += 1
    end

    @d.get(@url)
    @wait.until {@d.find_element(:class,"purchase-btn").displayed?}

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

  ensure
    # ログアウトしておく
    @d.find_element(:class,"logout").click
    @d.get(@url)
    @check_log.push(check_detail)
    # エラー発生有無に関係なく操作ウィンドウを元に戻す
    @d.switch_to.window( @window1_id )
    
  end
end

# 商品詳細ページでログアウト状態のユーザーには、「編集・削除・購入画面に進むボタン」が表示されないこと
def check_11
  check_detail = {"チェック番号"=> 11 , "チェック合否"=> "" , "チェック内容"=> "商品詳細ページでログアウト状態のユーザーには、「編集・削除・購入画面に進むボタン」が表示されないこと" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    if /編集/ .match(@d.page_source)
      check_detail["チェック詳細"] << "×：ログアウト状態のユーザーでは商品詳細画面にて商品の編集ボタンが表示されてしまう\n"
    else
      check_detail["チェック詳細"] << "◯：ログアウト状態のユーザーでは商品詳細画面にて商品の編集ボタンが表示されない\n"
      check_flag += 1
    end

    if /削除/ .match(@d.page_source)
      check_detail["チェック詳細"] << "×：ログアウト状態のユーザーでは商品詳細画面にて商品の削除ボタンが表示されてしまう\n"
    else
      check_detail["チェック詳細"] << "◯：ログアウト状態のユーザーでは商品詳細画面にて商品の削除ボタンが表示されない\n"
      check_flag += 1
    end

    if /購入画面に進む/.match(@d.page_source)
      check_detail["チェック詳細"] << "!：商品詳細画面に「購入ボタン」があるのでクリック\n"
      @d.find_element(:class,"item-red-btn").click
      @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

      if /会員情報入力/.match(@d.page_source)
        check_detail["チェック詳細"] << "◯：ログアウト状態では購入ページに遷移しようとすると、ログインページに遷移する\n"
        check_flag += 1
      else
        check_detail["チェック詳細"] << "×：ログアウト状態では購入ページに遷移しようとすると、ログインページに遷移しない\n"
      end
    else
      check_detail["チェック詳細"] << "◯：ログアウト状態のユーザーでは商品詳細画面にて購入ボタンが表示されない\n"
      check_flag += 1
    end

    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    check_detail["チェック合否"] = check_flag == 3 ? "◯" : "×"

  ensure
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    @check_log.push(check_detail)
  end
end

# ログイン状態の出品者以外のユーザーのみ、「購入画面に進むボタン」が表示されること
def check_12
  check_detail = {"チェック番号"=> 12 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態の出品者以外のユーザーのみ、「購入画面に進むボタン」が表示されること" , "チェック詳細"=> ""}
  check_flag = 0

  begin

    # トップページ　→　商品(コート)詳細画面へ遷移
    @wait.until {@d.find_element(:class,"item-img-content").displayed?}
    @d.find_element(:class,"item-img-content").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    if /購入画面に進む/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：出品者以外のログインユーザーだと商品詳細画面に「購入ボタン」が表示される\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：出品者以外のログインユーザーだと商品詳細画面に「購入ボタン」が表示されない\n"
    end

    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    @check_log.push(check_detail)
  end
end


# 価格の範囲が、¥300~¥9,999,999の間であること
def check_13
  check_detail = {"チェック番号"=> 13 , "チェック合否"=> "" , "チェック内容"=> "出品できる商品の価格の範囲が、¥300~¥9,999,999の間であること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    # user3でログイン
    login_any_user(@email3, @password)
    # トップ画面にて「出品」ボタンをクリックするメソッド
    click_purchase_btn(false)
    # 商品出品時の入力項目へ入力するメソッド
    # 価格設定299円で出品
    input_item_new_method(@item_name3, @item_info3, @item_price3, @item_image3)
    # 「出品する」ボタンをクリック
    @d.find_element(:class,"sell-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    jard
    if /商品の情報を入力/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：商品出品の際、価格を「299円」にすると出品できない\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：商品出品の際、価格を「299円」にすると出品できてしまう\n"
      # 出品できてしまった際は削除し出品画面へ戻ってくる
      return_purchase_before_delete_item(@item_name3)
    end

    # 1000万に再設定して再出品
    @item_price3 = 10000000
    clear_item_new_method
    input_item_new_method(@item_name3, @item_info3, @item_price3, @item_image3)
    @d.find_element(:class,"sell-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    jard
    if /商品の情報を入力/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：商品出品の際、価格を「1000万円」にすると出品できない\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：商品出品の際、価格を「1000万円」にすると出品できてしまう\n"
      # 出品できてしまった際は削除し出品画面へ戻ってくる
      return_purchase_before_delete_item(@item_name3)
    end

    # 300円に再設定して再出品
    @item_price3 = 300
    clear_item_new_method
    input_item_new_method(@item_name3, @item_info3, @item_price3, @item_image3)
    @d.find_element(:class,"sell-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    jard
    if /商品の情報を入力/.match(@d.page_source)
      check_detail["チェック詳細"] << "×：商品出品の際、価格を「300円」にすると出品できない\n"
    else
      check_detail["チェック詳細"] << "◯：商品出品の際、価格を「300円」にすると出品できる\n"
      check_flag += 1

      # 出品した際は削除し出品画面へ戻ってくる
      return_purchase_before_delete_item(@item_name3)
    end

    # 300円に再設定して再出品
    @item_price3 = 9999999
    clear_item_new_method
    input_item_new_method(@item_name3, @item_info3, @item_price3, @item_image3)
    @d.find_element(:class,"sell-btn").click
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
    jard
    if /商品の情報を入力/.match(@d.page_source)
      check_detail["チェック詳細"] << "×：商品出品の際、価格を「999万円」にすると出品できない\n"
    else
      check_detail["チェック詳細"] << "◯：商品出品の際、価格を「999万円」にすると出品できる\n"
      check_flag += 1

      # 出品した際は削除し出品画面へ戻ってくる
      return_purchase_before_delete_item(@item_name3)
    end

    check_detail["チェック合否"] = check_flag == 4 ? "◯" : "×"

  ensure
    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
    @check_log.push(check_detail)
  end
end


# basic認証が実装されている
def check_14
  check_detail = {"チェック番号"=> 14 , "チェック合否"=> "" , "チェック内容"=> "basic認証が実装されている" , "チェック詳細"=> ""}
  check_flag = 0

  begin

    # basic認証の情報を含まない本番環境のURLのみでアクセスしてみる
    @d.get("https://" + @url_ele)
    sleep 5

    display_flag = @d.find_element(:class,"furima-icon").displayed? rescue false
    # basic認証が実装されていたらトップ画面には遷移できないはず
    if display_flag
      check_detail["チェック詳細"] << "×：basic認証が実装されていない\n"
    else
      check_detail["チェック詳細"] << "◯：basic認証が実装されている\n"
      check_flag += 1
    end

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×";

  ensure
    @check_log.push(check_detail)
  end
end

# ログイン状態の出品者以外のユーザーは、URLを直接入力して出品していない商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること
def check_15
  check_detail = {"チェック番号"=> 15 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態の出品者以外のユーザーは、URLを直接入力して出品していない商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること" , "チェック詳細"=> ""}
  check_flag = 0

  begin

    # user2ログイン状態でコート(user1出品)編集画面に直接遷移する
    @d.get(@edit_url_coat)

    # 編集画面のロゴ画像にはクラス名が振られていないため「/商品の情報を入力/」としている
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    # トップページに遷移であれば正解
    if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
      check_detail["チェック詳細"] << "◯：出品者以外のログインユーザーが、URLを直接入力して出品していない商品の商品編集ページに遷移しようとすると、トップページへ遷移する\n"
      check_flag += 1
    elsif /会員情報入力/ .match(@d.page_source)
      check_detail["チェック詳細"] << "×：出品者以外のログインユーザーが、URLを直接入力して出品していない商品の商品編集ページに遷移しようとすると、ログインページへ遷移する\n"
    else
      check_detail["チェック詳細"] << "×：出品者以外のログインユーザーが、URLを直接入力して出品していない商品の商品編集ページに遷移しようとすると、トップページでもログインページでもないページへ遷移する\n"
    end

    @d.get(@url)
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    @check_log.push(check_detail)
  end
end


# 出品者・出品者以外にかかわらず、ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること
def check_16
  check_detail = {"チェック番号"=> 16 , "チェック合否"=> "" , "チェック内容"=> "出品者・出品者以外にかかわらず、ログイン状態のユーザーが、URLを直接入力して売却済み商品の商品情報編集ページへ遷移しようとすると、トップページに遷移すること" , "チェック詳細"=> ""}
  check_flag = 0

  begin

    # user2(出品者以外)がログイン状態で購入済みコートの商品編集画面に遷移(直接URL入力)
    @d.get(@edit_url_coat)
    # アイコンが表示されるまで待機
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    display_flag = @d.find_element(:class,"purchase-btn").displayed? rescue false
    # 出品ボタンの有無でトップページに遷移したかを判断
    if display_flag
      check_detail["チェック詳細"] << "○：出品者以外のユーザーが、売却済みの商品の商品情報編集ページにURLを直接入力して遷移しようとすると、トップページに遷移する\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：出品者以外のユーザーが、売却済みの商品の商品情報編集ページにURLを直接入力して遷移しようとすると、トップページに遷移しない\n"
    end

    # user1(出品者)にログイン
    login_any_user(@email, @password)

    # user1(出品者)がログイン状態で購入済みコートの商品編集画面に遷移(直接URL入力)
    @d.get(@edit_url_coat)
    # アイコンが表示されるまで待機
    @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

    display_flag = @d.find_element(:class,"purchase-btn").displayed? rescue false
    if display_flag
      check_detail["チェック詳細"] << "○：出品者が、自身の出品した売却済みの商品の商品情報編集ページにURLを直接入力して遷移しようとすると、トップページに遷移する\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：出品者が、自身の出品した売却済みの商品の商品情報編集ページにURLを直接入力して遷移しようとすると、トップページ以外に遷移する\n"
    end

    @d.get(@url)

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

  ensure
    # user2にログインして元に戻しておく
    login_any_user(@email2, @password)

    @check_log.push(check_detail)
    # エラー発生有無に関係なく操作ウィンドウを元に戻す
  end
end

# 入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)
def check_17
  check_detail = {"チェック番号"=> 17 , "チェック合否"=> "" , "チェック内容"=> "入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    # 商品価格のクラスをクリック？？
    @d.find_element(:class,"price-content").click

    #javascriptが動作しているかどうかを判断
    # 販売利益
    item_price_profit = (@item_price*0.9).round
    # 販売利益の[1,000]のコンマ表記バージョン
    item_price_profit2 = item_price_profit.to_s.gsub(/\@d{2}/, '\0,').to_s


    # 販売手数料(10%)
    item_price_commission = (@item_price*0.1).round
    # 販売利益の[1,000]のコンマ表記バージョン
    item_price_commission2 = item_price_commission.to_s.gsub(/\@d{2}/, '\0,').to_s

    check_detail["チェック詳細"] << "!価格設定：#{@item_price}円、販売手数料(10%)：#{item_price_commission}円、販売利益：#{item_price_profit}円\n"

    sleep 1

    item_commission = @d.find_element(:id,'add-tax-price').text rescue "販売手数料を表す[id: add-tax-price]が見つかりませんでした"
    item_profit = @d.find_element(:id,'profit').text rescue "販売利益を表す[id: profit]が見つかりませんでした"

    item_profit_flag1 = item_profit.to_s.include?(item_price_profit) rescue false
    item_profit_flag2 = item_profit.to_s.include?(item_price_profit2) rescue false

    item_commission_flag1 = item_commission.to_s.include?(item_price_commission) rescue false
    item_commission_flag2 = item_commission.to_s.include?(item_price_commission2) rescue false

    # 販売利益の整合性をチェック
    if item_profit_flag1 || item_profit_flag2
      check_detail["チェック詳細"] << "◯：入力された販売価格によって、非同期的に販売利益が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：入力された販売価格によって、非同期的に販売利益が表示されていない\n"
    end

    # 販売手数料の整合性をチェック
    if item_commission_flag1 || item_commission_flag2
      check_detail["チェック詳細"] << "◯：入力された販売価格によって、非同期的に販売手数料が表示されている\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：入力された販売価格によって、非同期的に販売手数料が表示されていない\n"
    end

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

  ensure
    @check_log.push(check_detail)
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



