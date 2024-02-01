# Furima_Check

## 概要
最終課題であるFurimaアプリの動作確認をする自動チェックツール

## image gif
[![Image from Gyazo](https://i.gyazo.com/baeb7cfcaea474db35386ca660ec9c6c.gif)](https://gyazo.com/baeb7cfcaea474db35386ca660ec9c6c)

## 動作環境
以下の環境を前提で進めます  
**MacOS・・・Mojave以上**  
**rubyのバージョン・・・2.5.0以上**  
**homebrew・・・インストール済み。※最新であれば問題ないです**  
※環境設定について不安な場合は環境構築カリキュラムを参考に変更してください  

## 導入手順
### ①rubyとhomebrewのバージョン確認  
ターミナルでバージョン確認のコマンドを実行し、数字が表示されればrubyとhomebrewはインストール済みです  
数字が表示されない場合はカリキュラムを参考にインストールしましょう  
```ruby
% ruby -v
2.6.0 #より大きい数字でも問題ありません

% brew -v
Homebrew 2.4.5 #より大きい数字でも問題ありません
```  

### ②必要なgemとパッケージのインストール
ターミナルのホームディレクトリで必要なgemとパッケージをインストールしましょう
```ruby
% gem install selenium-webdriver
% gem install google_driver
% brew install chromedriver
```

### ③本ツールのダウンロード
ターミナルでcdコマンドにより本ツールを設置したい箇所に移動し、以下コマンドで本ツールをダウンロードしましょう  
```ruby
% git clone https://github.com/we-b/Furima-Check.git
```

### ④動作確認ファイルを実行
ターミナルでcdコマンドによりクローンしたディレクトリに移動し、test.rbを実行しましょう  
「seleniumの初期設定完了しました。」と表示されれば導入は完了です  
```ruby
% ruby test.rb
Google
seleniumの初期設定完了しました。
```

## アプリの使い方

①ターミナルでcdコマンドによりFurima-Checkディレクトリまで移動する  
②ターミナルで以下コマンドを実行しチェックツールを立ち上げる  

```ruby
% ruby check.rb
```

③アプリURLとbasic認証のユーザー名とパスワードを入力する  
④終了まで画面を触らずに待機する  
⑤結果がターミナル及び[こちらのスプシ](https://docs.google.com/spreadsheets/d/1q_7tWEfvxIPglBNIkTIi2Uo_hIln5vd2ffIPc2f4crg/edit?usp=sharing)に表示されるため、どちらかで確認する  
（スプシを使用する場合は、 事前にスプシの「チェックを外す」ボタンをクリックしてチェック状況をクリアにしてください）  

## 詳しい仕様や注意点

・バックグラウンド実行の有無を切り替える際はcheck.rbの15行目と16行目のコメントアウトを逆にしてください  

・チェックツールの精度が低い箇所があるため、**基本的にチェックがついていない箇所は一度手動での確認もお願いします**  


## 参考資料
[テックキャンプ_エンジニア転職_ライフコーチ管理_自動チェックツールマニュアル](https://div.docbase.io/posts/1643990)  
[テックキャンプ_エンジニア転職_ライフコーチ管理_自動チェックツールインストール手順](https://div.docbase.io/posts/1664986)  
[テックキャンプ_エンジニア転職_ライフコーチ_全拠点_自動チェックツール_トラブルシューティング](https://div.docbase.io/posts/1492045)  
[テックキャンプ_エンジニア転職_ライフコーチ_全拠点_個人開発最終課題製作物確認マニュアル](https://div.docbase.io/posts/1438711)  
