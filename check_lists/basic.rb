def basic_check
    check_detail = {"チェック番号"=> 14 , "チェック合否"=> "" , "チェック内容"=> "basic認証が実装されている" , "チェック詳細"=> ""}
    check_flag = 0

    begin

        # basic認証の情報を含まない本番環境のURLのみでアクセスしてみる
        ## @d.get("https://" + @url_ele)
        ## localのときはhttp
            @d.get("http://" + @url_ele)
        sleep 1

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