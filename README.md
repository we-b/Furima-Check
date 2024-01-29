# Furima_Check

## 概要
最終課題であるFurimaアプリの動作確認をする自動チェックツール

## image gif（アプリの動作画像を入れる gifだとベスト）

## 動作環境
以下の環境を前提で進めます。
MacOS・・・Mojave以上
rubyのバージョン・・・2.5.0以上
homebrew・・・インストール済み。※最新であれば問題ないです。
※環境設定について不安な場合はPCの環境構築カリキュラムの「Homebrewを用意しよう」と「新しいバージョンのRubyをインストールしよう」を参考に変更してください。

## 導入手順
Rubyのバージョン確認方法
ターミナルでruby -vを実行し、数字が表示されていればRubyはインストール済みです。
数字が表示されない場合はカリキュラムを参考にインストールしましょう。

% ruby -v
2.6.0
homebrewのバージョン確認方法
ターミナルでbrew -vを実行し、数字が表示されていればhomebrewはインストール済みです。
数字が表示されない場合はカリキュラムを参考にインストールしましょう。

% brew -v
Homebrew 2.4.5
Seleniumのインストール
ホームディレクトリでgem install selenium-webdriverを実行しましょう。

% gem install selenium-webdriver
Successfully installed selenium-webdriver-3.142.7
Parsing documentation for selenium-webdriver-3.142.7
Installing ri documentation for selenium-webdriver-3.142.7
Done installing documentation for selenium-webdriver after 1 seconds
1 gem installed
※ディレクトリについてはこちらのカリキュラムを参照してください。

chromedriverのインストール
brew install chromedriverを実行しましょう。

% brew install chromedriver
インストールが完了するとchromedriver was successfully installed!と表示されます。

% brew install chromedriver
==> Satisfying dependencies
==> Downloading https://chromedriver.storage.googleapis.com/75.0.3770.8/chromedriver_mac64.zip
######################################################################## 100.0%
==> Verifying SHA-256 checksum for  'chromedriver'.
==> Installing  chromedriver
==> Linking Binary 'chromedriver' to '/usr/local/bin/chromedriver'.
🍺  chromedriver was successfully installed!
エラーが出た場合
brew cask install chromedriverを実行しましょう。

% brew cask install chromedriver
インストールが完了するとchromedriver was successfully installed!と表示されます。

% brew cask install chromedriver
==> Satisfying dependencies
==> Downloading https://chromedriver.storage.googleapis.com/75.0.3770.8/chromedriver_mac64.zip
######################################################################## 100.0%
==> Verifying SHA-256 checksum for Cask 'chromedriver'.
==> Installing Cask chromedriver
==> Linking Binary 'chromedriver' to '/usr/local/bin/chromedriver'.
🍺  chromedriver was successfully installed!
selenium-webdriverが動作するか確認
Githubからファイルをクローンする
~/projectsのディレクトリで下記コマンドを実行しましょう。

projectsディレクトリがない場合はこちらのカリキュラムを参考に作成しましょう。

ProtoSpaceの場合
% git clone https://github.com/we-b/protospace_check.git

Furimaの場合
% git clone https://github.com/we-b/Furima-Check.git
以下のように「done」と表示できていれば git cloneはできています。

% cd projects
% git clone https://github.com/we-b/Furima-Check.git
Cloning into 'Furima-Check'...
remote: Enumerating objects: 174, done.
remote: Counting objects: 100% (174/174), done.
remote: Compressing objects: 100% (106/106), done.
remote: Total 174 (delta 109), reused 129 (delta 64), pack-reused 0
Receiving objects: 100% (174/174), 163.61 KiB | 452.00 KiB/s, done.
Resolving deltas: 100% (109/109), done.
gemをインストールする（Furimaアプリのみ）
gemをインストールするためにFurima-Checkディレクトリに移動し、以下のコマンドを入力し実行ましょう

% cd projects
% cd Furima-Check
% bundle update
% bundle install
エラーが起こる場合
スクリーンショット 2020-12-21 18.08.09.png

上記のようなエラーが起こる場合はターミナルで指示されているgem install bundler: ○○○を実行して下さい、実行コマンドはPC環境によって変わります。

ダウンロードしたファイルを実行
先程クローンをしたディレクトリで、test.rbを実行してください。
ターミナルに「Google」と出力できていればseleniumの環境構築は完了です。

・test.rbのプログラムを実行

%  ruby test.rb
・実行結果が以下のようになっていれば環境構築は完了です。

% ruby test.rb
Google
seleniumの初期設定完了しました。
※「A-245」の部分は人によって違います。

エラーが出る場合
開発元を検証できないため開けませんという文字が表示された場合以下の手順を行いましょう。
スクリーンショット 2020-12-09 15.18.25.png

①システム環境設定→セキュリティとプライバシーの一般タブを開く
セキュリティとプライバシーの一般タブの画面でダウンロードしたアプリケーションの実行許可を求められるので 「このまま許可」 を押す
スクリーンショット 2020-12-09 15.19.01.png

②もう一度ファイルを実行し、「開く」を押す
「開く」を押した後にファイルを実行を行い、「Google」とターミナルに出力されるか確認しましょう。
スクリーンショット 2020-12-09 15.19.18.png

## アプリの使い方

①ターミナルでcdコマンドによりFurima-Checkディレクトリまで移動する  
②ターミナルで以下コマンドを実行しチェックツールを立ち上げる  

```
% ruby check.rb
```

③アプリURLとbasic認証のユーザー名とパスワードを入力する  
④終了まで画面を触らずに待機する  
⑤結果がターミナル及び[こちらのスプシ](https://docs.google.com/spreadsheets/d/1q_7tWEfvxIPglBNIkTIi2Uo_hIln5vd2ffIPc2f4crg/edit?usp=sharing)に表示されるため、どちらかで確認する 
（スプシを使用する場合は、 事前にスプシの「チェックを外す」ボタンをクリックしてチェック状況をクリアにしてください）  

## 詳しい仕様や注意点

①バックグラウンド実行の有無を切り替える際はcheck.rbの15行目と16行目のコメントアウトを逆にしてください  

②チェックツールの精度が低い箇所があるため、**基本的にチェックがついていない箇所は一度手動での確認もお願いします**  
特にJSのturboが関わる箇所についてはリロードの有無により処理が変わる可能性があるため、手動での確認が多くなる想定です  
（JSについては手動での確認が必要な際はターミナルの出力結果に表示されます）  


## 参考資料
テックキャンプ_エンジニア転職_ライフコーチ管理_自動チェックツールマニュアル
https://div.docbase.io/posts/1643990

テックキャンプ_エンジニア転職_ライフコーチ管理_自動チェックツールインストール手順
https://div.docbase.io/posts/1664986

テックキャンプ_エンジニア転職_ライフコーチ_全拠点_自動チェックツール_トラブルシューティング
https://div.docbase.io/posts/1492045

テックキャンプ_エンジニア転職_ライフコーチ_全拠点_個人開発最終課題製作物確認マニュアル
https://div.docbase.io/posts/1438711