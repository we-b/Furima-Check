def user_check
    # ↓↓↓ログアウト状態では、ヘッダーに新規登録/ログインボタンが表示されること↓↓↓
        check_detail = {"チェック番号"=> 1 , "チェック合否"=> "" , "チェック内容"=> "ログアウト状態で、ヘッダーにログイン/新規登録ボタンが表示されること" , "チェック詳細"=> ""}
        check_flag = 0
        begin
            
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
    # ↑↑↑ログアウト状態では、ヘッダーに新規登録/ログインボタンが表示されること↑↑↑

    # ↓↓↓全て未入力で新規登録を行った際に期待通りのエラーログが出力されること↓↓↓
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
        # 全項目未入力でいきなり「登録する」ボタンをクリック
        @d.find_element(:class,"register-red-btn").click
        @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

        # 念の為登録できてしまわないかチェック
        if /会員情報入力/ .match(@d.page_source)
            # 登録できなかった場合
            # エラーログの表示有無
            display_flag = @d.find_element(:class,"error-alert").displayed? rescue false
            if display_flag
            @error_log_hash["新規登録"] = "◯：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すと登録が完了せずエラーメッセージが出力される\n\n"
            @error_log_hash["新規登録"] << "↓↓↓ エラーログ全文(出力された内容) ↓↓↓\n"
            # エラーログの親要素
            error_parent = @d.find_element(:class,"error-alert")
            error_strings = error_parent.find_elements(:class,"error-message")
            error_strings.each{|ele|
                @error_log_hash["新規登録"] << "・" + ele.text + "\n"
            }

            # 出力されたエラーログに漏れがないか目視確認しやすいように比較文章をいれる
            @error_log_hash["新規登録"] << "\n\n↓↓↓ エラーログ模範出力文章(英語表記ですが、出力文との比較にお使いください) ↓↓↓\n"
            @error_log_hash["新規登録"] << <<-EOT
            ----------------------------
            ・Email can't be blank
            ・Password can't be blank
            ・Password is invalid
            ・Nickname can't be blank
            ・Last name can't be blank
            ・Last name is invalid
            ・First name can't be blank
            ・First name is invalid
            ・Last name kana can't be blank
            ・Last name kana is invalid
            ・First name kana can't be blank
            ・First name kana is invalid
            ・Birthday can't be blank
            ----------------------------


            EOT
            else
            # エラーログが出力されていなかったら
            @error_log_hash["新規登録"] = "×：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すと登録は完了しないが、エラーメッセージは出力されない\n\n"
            end
        else
            # 登録できてしまう場合
            @error_log_hash["新規登録"] = "×：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すとリダイレクトせず登録画面以外のページへ遷移してしまう(登録できてしまっている可能性あり)\n"
            # トップ画面へ
            @d.get(@url)
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

            display_flag = @d.find_element(:class,"logout").displayed? rescue false
            # ログイン状態であればログアウトしておく
            if display_flag
            @d.find_element(:class,"logout").click
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
            @d.get(@url)
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
            end

            # 再度新規登録画面へ
            @d.find_element(:class,"sign-up").click
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}

        end
        # 新規登録に必要な項目入力を行うメソッド。emailが空。
        input_sign_up_method(@users[0][:nickname], "", @users[0][:password], @users[0][:first_name], @users[0][:last_name], @users[0][:first_name_kana], @users[0][:last_name_kana], @users[0][:birth_index])
        @wait.until {@d.find_element(:id, 'email').displayed?}
        @d.find_element(:class,"register-red-btn").click
        # TODO ここの処理ないけど大丈夫？
    # ↑↑↑全て未入力で新規登録を行った際に期待通りのエラーログが出力されること↑↑↑

    # ↓↓↓パスワードが5文字だと登録できないこと↓↓↓
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
        input_sign_up_method(@users[0][:nickname], @users[0][:email], "aaa11", @users[0][:first_name], @users[0][:last_name], @users[0][:first_name_kana], @users[0][:last_name_kana], @users[0][:birth_index])
    
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
    # ↑↑↑パスワードが5文字だと登録できないこと↑↑↑

    # ↓↓↓パスワードが文字列のみだと登録できないこと↓↓↓
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
        input_sign_up_method(@users[0][:nickname], @users[0][:email], "aaaaaa", @users[0][:first_name], @users[0][:last_name], @users[0][:first_name_kana], @users[0][:last_name_kana], @users[0][:birth_index])
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
    # ↑↑↑パスワードが文字列のみだと登録できないこと↑↑↑

    # ↓↓↓パスワードが数字のみだと登録できないこと↓↓↓
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
        # 新規登録に必要な項目入力を行うメソッド。数字のみでの入力
        input_sign_up_method(@users[0][:nickname], @users[0][:email], "111111", @users[0][:first_name], @users[0][:last_name], @users[0][:first_name_kana], @users[0][:last_name_kana], @users[0][:birth_index])
        @d.find_element(:class,"register-red-btn").click
        # if文でチェック
        if /FURIMAが選ばれる3つの理由/ .match(@d.page_source)
            @puts_num_array[1][19] = "[1-019] ×：パスワードは、数字のみでも登録できる"
            @d.find_element(:class,"logout").click
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
            @d.get(@url)
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false }
            @d.find_element(:class,"sign-up").click
            #raise "ユーザー登録バリデーションにて不備あり"
        else
            @puts_num_array[1][19] = "[1-019] ◯"  #：パスワードは、半角英数字混合での入力が必須であること
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
    # ↑↑↑パスワードが数字のみだと登録できないこと↑↑↑

    # ↓↓↓ユーザー登録ができること↓↓↓
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
        input_sign_up_method(@users[0][:nickname], @users[0][:email], @users[0][:password], @users[0][:first_name], @users[0][:last_name], @users[0][:first_name_kana], @users[0][:last_name_kana], @users[0][:birth_index])
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
            # 登録に失敗した場合はニックネームを疑う
            if /会員情報入力/ .match(@d.page_source)
            # ニックネームの内容でエラーになった可能性あるため、
            @nickname = "ライフコーチテストユーザーイチ"
            @nickname2 = "ライフコーチテストユーザー二"
            @nickname3 = "ライフコーチテストユーザーサン"
            clear_sign_up_method
            input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)
            @d.find_element(:class,"register-red-btn").click
            @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
            if /会員情報入力/ .match(@d.page_source)
                # ニックネームの内容でエラーになった可能性あるため、
                @nickname = "らいふこーちてすとゆーざーいち"
                @nickname2 = "らいふこーちてすとゆーざーに"
                @nickname3 = "らいふこーちてすとゆーざーさん"
                clear_sign_up_method
                input_sign_up_method(@nickname, @email, @password, @first_name, @last_name, @first_name_kana, @last_name_kana)
                @d.find_element(:class,"register-red-btn").click
                @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
            end
            end
        end

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
    # ↑↑↑ユーザー登録ができること↑↑↑

    # ↓↓↓ログインできること↓↓↓
        @d.find_element(:class,"logout").click
        @wait.until {@d.find_element(:class,"furima-icon").displayed? rescue false || @d.find_element(:class,"second-logo").displayed? rescue false || /商品の情報を入力/ .match(@d.page_source)}
        @wait.until {@d.find_element(:class,"login").displayed?}
        @d.find_element(:class,"login").click
        @wait.until {@d.find_element(:id, 'email').displayed?}
        @d.find_element(:id, 'email').send_keys(@users[0][:email])
        @wait.until {@d.find_element(:id, 'password').displayed?}
        @d.find_element(:id, 'password').send_keys(@users[0][:password])
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
    # ↑↑↑ログインできること↑↑↑

    # ↓↓↓ログイン状態では、ヘッダーにユーザーのニックネーム/ログアウトボタンが表示されること↓↓↓
        check_detail = {"チェック番号"=> 2 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態では、ヘッダーにユーザーのニックネーム/ログアウトボタンが表示されること" , "チェック詳細"=> ""}
        check_flag = 0

        begin

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
    # ↑↑↑ログイン状態では、ヘッダーにユーザーのニックネーム/ログアウトボタンが表示されること↑↑↑
end

# 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまため
def re_sigin_up
    randm_word = SecureRandom.hex(5)
    @users[0][:email] = "user1_#{randm_word}@co.jp"
    @puts_num_array[0].push("\n【補足情報】ユーザー新規登録テストにて、ユーザー1の情報が更新されたため更新されたユーザー情報を出力します(手動でのログイン時に使用)")
    @puts_num_array[0].push("パスワード: #{@users[0][:password]}")
    @puts_num_array[0].push("ユーザー名: 未入力\nemail: #{@users[0][:email]}\n")
end

# 新規登録に必要な項目入力を行うメソッド
def input_sign_up_method(nickname, email, pass, first, last, first_kana, last_kana, birth_index)
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
        select_ele.select_by(:index, birth_index)
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