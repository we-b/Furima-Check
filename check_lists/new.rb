def new_check
    # ↓↓↓価格のチェック↓↓↓
        @wait.until {@d.find_element(:class,"purchase-btn").displayed?}
        # トップ画面で出品ボタンをクリック
        click_purchase_btn(true)

        # activehashの各項目の表示名が正しいか
            # カテゴリーは、「---、メンズ、レディース、ベビー・キッズ、インテリア・住まい・小物、本・音楽・ゲーム、おもちゃ・ホビー・グッズ、家電・スマホ・カメラ、スポーツ・レジャー、ハンドメイド、その他」の11項目が表示されること（--- は初期値として設定すること）
                begin
                    selectCategory = @d.find_element(:id,"item-category")
                rescue 
                    puts "×：商品カテゴリー(id名：item-category)が存在しませんでした\n"
                end
                
                selectCategory = Selenium::WebDriver::Support::Select.new(selectCategory)
                selectCategoryOp = selectCategory.options
                selectCategories = []
                
                for name in selectCategoryOp
                selectCategories<< name.text
                end
                select_category_any = [ "レディース","メンズ","レディース", "ベビー・キッズ","インテリア・住まい・小物","本・音楽・ゲーム","おもちゃ・ホビー・グッズ","家電・スマホ・カメラ","スポーツ・レジャー","ハンドメイド","その他"]
                if select_category_any.all? {|i| selectCategories.include?(i)}
                @puts_num_array[2][15] = "[2-015] ◯"
                else
                false_selects =[]
                selectCategories.each{|check_select|
                    select_category_any.include?(check_select) ?  "" : false_selects<<check_select
                }
                @puts_num_array[2][15] = "[2-015] ×：【101期以降】商品カテゴリーの要件を満たしてません。誤って実装されているカテゴリー→ #{false_selects}"
                end

            # 商品の状態は、「---、新品・未使用、未使用に近い、目立った傷や汚れなし、やや傷や汚れあり、傷や汚れあり、全体的に状態が悪い」の7項目が表示されること（--- は初期値として設定すること）
                begin
                    selectCategory = @d.find_element(:id,"item-sales-status")
                rescue 
                    begin
                        selectCategory = @d.find_element(:id,"item-condition")
                    rescue
                        puts "×：商品カテゴリー(id名：item-sales-status)が存在しませんでした\n"
                    end
                end
                
                selectCategory = Selenium::WebDriver::Support::Select.new(selectCategory)
                selectCategoryOp = selectCategory.options
                selectCategories  = []
                
                for name in selectCategoryOp
                selectCategories  << name.text
                end
                
                select_category_any = ["新品・未使用", "未使用に近い", "目立った傷や汚れなし", "やや傷や汚れあり", "傷や汚れあり", "全体的に状態が悪い"]
                if select_category_any.all? {|i| selectCategories.include?(i)}
                @puts_num_array[2][16] = "[2-016] ◯"
                else
                false_selects =[]
                selectCategories.each{|check_select|
                    select_category_any.include?(check_select) ?  "" : false_selects<<check_select
                }
                @puts_num_array[2][16] = "[2-016] ×：【101期以降】商品の状態の要件を満たしてません。誤って実装されている商品の状態カテゴリー→ #{false_selects}"
                end

            # 配送料の負担は、「---、着払い(購入者負担)、送料込み(出品者負担)」の3項目が表示されること（--- は初期値として設定すること）
                begin
                    selectCategory = @d.find_element(:id,"item-shipping-fee-status")
                rescue
                    begin
                        selectCategory = @d.find_element(:id,"item-shipping-charge")
                    rescue
                        puts "×：配送料(id名：item-shipping-fee-status)が存在しませんでした\n"
                    end
                end
                
                selectCategory = Selenium::WebDriver::Support::Select.new(selectCategory)
                selectCategoryOp = selectCategory.options
                selectCategories  = []
                
                for name in selectCategoryOp
                    selectCategories  << name.text
                end
                
                select_category_any = [ "着払い(購入者負担)", "送料込み(出品者負担)"]
                if select_category_any.all? {|i| selectCategories.include?(i)}
                    @puts_num_array[2][17] = "[2-017] ◯"
                else
                    false_selects =[]
                    selectCategories.each{|check_select|
                        select_category_any.include?(check_select) ?  "" : false_selects<<check_select
                    }
                    @puts_num_array[2][17] = "[2-017] ×：【101期以降】配送料の負担の要件を満たしてません。誤って実装されている配送料カテゴリー→ #{false_selects}"
                end

            # 発送元の地域は、「---」と47都道府県の合計48項目が表示されること（--- は初期値として設定すること）
                begin
                    selectCategory = @d.find_element(:id,"item-prefecture")
                rescue 
                    puts "×：発送元の地域(id名：item-prefecture)が存在しませんでした\n"
                end
                
                selectCategory = Selenium::WebDriver::Support::Select.new(selectCategory)
                selectCategoryOp = selectCategory.options
                selectCategories  = []
                
                for name in selectCategoryOp
                    selectCategories  << name.text
                end
                
                select_category_any = ["北海道", "青森県", "岩手県",  "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
                if select_category_any.all? {|i| selectCategories.include?(i)}
                    @puts_num_array[2][18] = "[2-018] ◯"
                else
                    false_selects =[]
                    selectCategories.each{|check_select|
                        select_category_any.include?(check_select) ?  "" : false_selects<<check_select
                    }
                    @puts_num_array[2][18] = "[2-018] ×：【101期以降】発送元の地域の要件を満たしてません。誤って実装されている発送元の地域カテゴリー→ #{false_selects}"
                end
        
            # 発送までの日数は、「---、1~2日で発送、2~3日で発送、4~7日で発送」の4項目が表示されること（--- は初期値として設定すること）
                begin
                    selectCategory = @d.find_element(:id,"item-scheduled-delivery")
                rescue 
                    begin
                        selectCategory = @d.find_element(:id,"item-shipping_date")
                    rescue
                        puts "×：発送までの日数(id名：item-scheduled-delivery)が存在しませんでした\n"
                    end
                end
                
                selectCategory = Selenium::WebDriver::Support::Select.new(selectCategory)
                selectCategoryOp = selectCategory.options
                selectCategories  = []
                
                for name in selectCategoryOp
                    selectCategories  << name.text
                end
                
                select_category_any = [ "1~2日で発送", "2~3日で発送", "4~7日で発送"]
                if select_category_any.all? {|i| selectCategories.include?(i)}
                    @puts_num_array[2][19] = "[2-019] ◯"
                else
                    false_selects =[]
                    selectCategories.each{|check_select|
                        select_category_any.include?(check_select) ?  "" : false_selects<<check_select
                    }
                    @puts_num_array[2][19] = "[2-019] ×：【101期以降】発送までの日数の要件を満たしてません。誤って実装されている発送までの日数カテゴリー→ #{false_selects}"
                end
        
        # 商品出品画面でのエラーハンドリングログを取得
            # 全項目未入力でいきなり「出品する」ボタンをクリック
            @d.find_element(:class,"sell-btn").click
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

            # 念の為出品できてしまわないかチェック
            if /商品の情報を入力/ .match(@d.page_source)
                # 出品できなかった場合
                # エラーログの表示有無
                display_flag = @d.find_element(:class,"error-alert").displayed? rescue false
                if display_flag
                @error_log_hash["商品出品"] = "◯：【商品出品画面】にて全項目未入力の状態で出品ボタンを押すと出品が完了せずエラーメッセージが出力される\n\n"
                @error_log_hash["商品出品"] << "↓↓↓ エラーログ全文(出力された内容) ↓↓↓\n"
                # エラーログの親要素
                error_parent = @d.find_element(:class,"error-alert")
                error_strings = error_parent.find_elements(:class,"error-message")
                error_strings.each{|ele|
                    @error_log_hash["商品出品"] << "・" + ele.text + "\n"
                }

                # 出力されたエラーログに漏れがないか目視確認しやすいように比較文章をいれる
                @error_log_hash["商品出品"] << "\n\n↓↓↓ エラーログ模範出力文章(英語表記ですが、出力文との比較にお使いください) ↓↓↓\n"
                @error_log_hash["商品出品"] << <<-EOT
                ----------------------------
                ・Name can't be blank
                ・Description can't be blank
                ・Price can't be blank
                ・Price is not included in the list
                ・Image can't be blank
                ・Category must be other than 0
                ・Condition must be other than 0
                ・Cost beaver must be other than 0
                ・Shipment area must be other than 0
                ・Preparation days must be other than 0
                ----------------------------


                EOT
                else
                # エラーログが出力されていなかったら
                @error_log_hash["商品出品"] = "×：【商品出品画面】にて全項目未入力の状態で出品ボタンを押すと出品は完了しないが、エラーメッセージは出力されない\n\n"
                end
            else
                # 出品できてしまう場合
                @error_log_hash["商品出品"] = "×：【商品出品画面】にて全項目未入力の状態で出品ボタンを押すとリダイレクトせず商品出品画面以外のページへ遷移してしまう(出品できてしまっている可能性あり)\n"
                # トップ画面へ
                @d.get(@url)
                @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

                # 再度出品画面へ
                click_purchase_btn(false)
            end

        
        # 商品出品時の必須項目へ入力するメソッド
        input_item_new_method(@items[0][:name], @items[0][:info], @items[0][:price], @items[0][:image])
        sleep 1
        # 入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)
            check_detail = {"チェック番号"=> 17 , "チェック合否"=> "" , "チェック内容"=> "入力された販売価格によって、販売手数料や販売利益が変わること(JavaScriptを使用して実装すること)" , "チェック詳細"=> ""}
            check_flag = 0

            begin
                # 商品価格のクラスをクリック？？
                @d.find_element(:class,"price-content").click

                #javascriptが動作しているかどうかを判断
                # 販売利益
                item_price_profit = (@items[0][:price]*0.9).round.to_s
                # 販売利益の[1,000]のコンマ表記バージョン
                item_price_profit2 = item_price_profit.to_s.reverse.gsub(/\d{3}/, '\0,').reverse


                # 販売手数料(10%)
                item_price_commission = (@items[0][:price]*0.1).round.to_s
                # 販売利益の[1,000]のコンマ表記バージョン
                item_price_commission2 = item_price_commission.to_s.reverse.gsub(/\d{3}/, '\0,').reverse

                check_detail["チェック詳細"] << "!価格設定：#{@items[0][:price]}円、販売手数料(10%)：#{item_price_commission}円、販売利益：#{item_price_profit}円\n"

                sleep 1

                item_commission = @d.find_element(:id,'add-tax-price').text rescue "販売手数料を表す[id: add-tax-price]が見つかりませんでした"
                item_profit = @d.find_element(:id,'profit').text rescue "販売利益を表す[id: profit]が見つかりませんでした"

                item_profit_flag1 = item_profit.to_s.include?(item_price_profit) rescue false
                item_profit_flag2 = item_profit.to_s.include?(item_price_profit2) rescue false

                item_commission_flag1 = item_commission.to_s.include?(item_price_commission) rescue false
                item_commission_flag2 = item_commission.to_s.include?(item_price_commission2) rescue false
                
                sleep 1

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
    # ↑↑↑価格のチェック↑↑↑

    # ↓↓↓エラーハンドリングのチェック↓↓↓
        clear_item_new_method

        input_item_new_method(@items[0][:name], @items[0][:info], @items[0][:price], @items[0][:image])
    
        # 商品情報のセレクトタグにて選択した情報を変数に代入
        @item_category_word = select_new(@d.find_element(:id,"item-category")).selected_options[0].text
    
        begin
        @item_status_word = select_new(@d.find_element(:id,"item-sales-status")).selected_options[0].text
        rescue
        @item_status_word = select_new(@d.find_element(:id,"item-condition")).selected_options[0].text
        end
    
        begin
        @item_shipping_fee_status_word = select_new(@d.find_element(:id,"item-shipping-fee-status")).selected_options[0].text
        rescue
        @item_shipping_fee_status_word = select_new(@d.find_element(:id,"item-shipping-charge")).selected_options[0].text
        end
        
        @item_prefecture_word          = select_new(@d.find_element(:id,"item-prefecture")).selected_options[0].text
        
        begin
        @item_scheduled_delivery_word  = select_new(@d.find_element(:id,"item-scheduled-delivery")).selected_options[0].text
        rescue
        @item_scheduled_delivery_word  = select_new(@d.find_element(:id,"item-shipping_date")).selected_options[0].text
        end
    
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
        @puts_num_array[2][20] = "[2-020] ○"  #：出品が完了したら、トップページに遷移すること"
        end
    # ↑↑↑エラーハンドリングのチェック↑↑↑

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
    @wait.until {@d.find_element(:id,"item-info").displayed? rescue @d.find_element(:id,"item-description").displayed? } 
    @d.find_element(:id,"item-info").send_keys(info) rescue @d.find_element(:id,"item-description").send_keys(info)
  
    # カテゴリーはセレクトタグから値を選択
    @wait.until {@d.find_element(:id,"item-category").displayed?}
    item_category_element = @d.find_element(:id,"item-category")
    item_category = select_new(item_category_element)
    item_category.select_by(:value, @items[0][:activehash_value])
  
    # 商品の状態はセレクトタグから値を選択
    @wait.until {@d.find_element(:id,"item-sales-status").displayed? rescue @d.find_element(:id,"item-condition").displayed?}
    item_sales_status_element = @d.find_element(:id,"item-sales-status") rescue item_sales_status_element = @d.find_element(:id,"item-condition")
    item_sales_status = select_new(item_sales_status_element)
    item_sales_status.select_by(:value, @items[0][:activehash_value])
  
    # 送料の負担はセレクトタグから値を選択
    @wait.until {@d.find_element(:id,"item-shipping-fee-status").displayed? rescue @d.find_element(:id,"item-shipping-charge").displayed?}
    item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-fee-status")rescue item_shipping_fee_status_element = @d.find_element(:id,"item-shipping-charge")
    item_shipping_fee_status = select_new(item_shipping_fee_status_element)
    item_shipping_fee_status.select_by(:value, @items[0][:activehash_value])
  
    # 発送先はセレクトタグから値を選択
    @wait.until {@d.find_element(:id,"item-prefecture").displayed?}
    item_prefecture_element = @d.find_element(:id,"item-prefecture")
    item_prefecture = select_new(item_prefecture_element)
    item_prefecture.select_by(:value, @items[0][:activehash_value])
  
    # 発送までの日数
    @wait.until {@d.find_element(:id,"item-scheduled-delivery").displayed? rescue @d.find_element(:id,"item-shipping_date").displayed?}
    item_scheduled_delivery_element = @d.find_element(:id,"item-scheduled-delivery") rescue item_scheduled_delivery_element = @d.find_element(:id,"item-shipping_date")
    item_scheduled_delivery = select_new(item_scheduled_delivery_element)
    item_scheduled_delivery.select_by(:value, @items[0][:activehash_value])
  
  
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
    @d.find_element(:id,"item-info").clear rescue @d.find_element(:id,"item-description").clear
  
    item_category_blank = @d.find_element(:id,"item-category")
    item_category_blank = select_new(item_category_blank)
    item_category_blank.select_by(:value, @items[0][:activehash_blank_value])
  
    item_sales_status_blank = @d.find_element(:id,"item-sales-status") rescue item_sales_status_blank = @d.find_element(:id,"item-condition")
    item_sales_status_blank = select_new(item_sales_status_blank )
    item_sales_status_blank.select_by(:value, @items[0][:activehash_blank_value])
  
    item_shipping_fee_status_blank = @d.find_element(:id,"item-shipping-fee-status") rescue item_shipping_fee_status_blank = @d.find_element(:id,"item-shipping-charge")
    item_shipping_fee_status_blank = select_new(item_shipping_fee_status_blank )
    item_shipping_fee_status_blank.select_by(:value, @items[0][:activehash_blank_value])
  
    item_prefecture_blank = @d.find_element(:id,"item-prefecture")
    item_prefecture_blank = select_new(item_prefecture_blank )
    item_prefecture_blank.select_by(:value, @items[0][:activehash_blank_value])
  
    item_scheduled_delivery_blank = @d.find_element(:id,"item-scheduled-delivery") rescue item_scheduled_delivery_blank = @d.find_element(:id,"item-shipping_date")
    item_scheduled_delivery_blank = select_new(item_scheduled_delivery_blank )
    item_scheduled_delivery_blank.select_by(:value, @items[0][:activehash_blank_value])
  
    # 価格
    @d.find_element(:id,"item-price").clear
end
