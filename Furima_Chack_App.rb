require 'selenium-webdriver'
@wait = Selenium::WebDriver::Wait.new(:timeout => 180000)
@d = Selenium::WebDriver.for :chrome


#basic認証のidとpass
b_id = "admin"
b_password = "1111"
@http ="http://#{b_id}:#{b_password}@"
# 受講生の@URLをhttp://以降から記入

# @url = "#{@http}furima-11111.herokuapp.com/"
@url = "http://localhost:3000/"


@item_image = "/Users/tech-camp/projects/furima_checkApp/photo/coat.jpg"
@item_image2 = "/Users/tech-camp/projects/furima_checkApp/photo/sunglass.jpg"


@nickname = "kusunnjyun"
@email = "divssd13s8@co.jp"
@password = "aaa111"
@first_name = "愛"
@last_name= "不時着"
@first_name_kana = "アイ"
@last_name_kana = "フジチャク"

@nickname2 = "class"
@email2 = "dssaf06s8@co.jp"
@first_name2 = "梨泰"
@user_last_name2 = "院"
@first_name_kana2 = "イテウォン"
@last_name_kana2 = "クラス"



@item_image_name = "coat.jpg"
@item_name = "コート"
@item_info = "今年イチオシのトレンチコート"
@item_info_re = "昨年イチオシのトレンチコート"
@value = '2'

@item_price = 40000


@item_name2 = "サングラス"
@item_info2 = "限定5品のサングラス"

@item_price2 = 30000

@card_number = 4242424242424242
@card_exp_month = 10
@card_exp_year = 30
@card_cvc = 123
@postal_code = "965-0873"
@prefecture = "福島県"
@city = "会津若松市" 
@addresses = "追手町１−１"
@phone_number = "02089001111"

@blank = "1"

require './main'

main()

