# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## アプリケーション名
花山リマインダー（Hanayama Reminder）

## アプリケーション概要
「花山リマインダー」は、山の花の開花時期を追跡し、見頃の時期を通知するアプリケーションです。  
登山愛好家や花の観察を楽しむ方々が、最適なタイミングで山の花や高山植物に出会えるようサポートします。

・自分の行くエリアを選択し、「今見頃の花＆山」が一覧で見れる  
・通知設定をすれば、開花前からリマインドしてくれるので登山計画が立てやすい  
・エリアの見頃の花の情報や登山スポットの詳細も確認可能  
・リアルタイム投稿もできるから、コミュニティで最新の開花情報を共有  
・働き盛りの「20~30代女性ハイカー（登山好き）」必見  

## URL
https://hanayama-reminder-app-42329.onrender.com
<br>※デプロイ済みのURLを記載。デプロイが済んでいない場合は、デプロイが完了次第記載すること。

## テスト用アカウント
テスト用Email：usagi@mail
<br>テスト用Password：usa111
<br>ログイン：上記のメールアドレス・パスワードを入力
<br>※Basic認証 ID:momonst /Pass: 0407

## 利用方法
1. URLにアクセスし、ヘッダーの「ログイン」ボタンからログイン画面に移動します。
2. テスト用アカウントを使用しログインします。
3. トップページのヘッダー右上のプルダウンメニューから「投稿する」をクリックし、花や山に関する写真を投稿します。  
・投稿には、花の名前・登山スポット・写真1枚・コメントを入力できます。
4. トップページでは、他のユーザーが投稿した「花×山スポット」の情報が一覧表示されます。  
・エリアで絞り込み検索が可能です。
5. 投稿の詳細画面では、スポットに関する情報や投稿者コメントを確認できます。
6. 気に入った投稿には「いいね」を押すことで投稿ランキングに反映されます。
7. お気に入り登録した投稿は、マイページ・お気に入り一覧からいつでも確認できます。
8. 自分が投稿した内容は、マイページまたは投稿の詳細画面から「編集」や「削除」が可能です。
9. 見頃の花情報は、毎月もしくは毎週通知される「花山リマインダー」機能で確認できます。
10. 地図ページでは、Google Maps上に花と山のスポットが表示され、位置情報を確認しながら登山計画を立てることができます。


## アプリケーションを作成した背景
花の見頃は短く、場所によって時期が大きく違うため、見逃しやすいという声が多い。
<br>特に、仕事で忙しいユーザーは、登山計画と花のタイミングを合わせづらい。
<br>さらに、既存サービスでは「当日に特化」したアプリが多く、「事前準備に特化」したアプリがあれば、ニーズに応える価値があると判断したため。
<br>ユーザー参加型で、使えば使うほどデータが蓄積され、翌年の楽しみが増える＆新しい発見ができて、登山に行くきっかけになるリマインダーを目指します。

## 実装した機能についての画像やGIFおよびその説明
|ページ|説明|
|---|------------------|
|[![Image from Gyazo](https://i.gyazo.com/7a690d74f221ff9885709f5f406e9ec7.gif)](https://gyazo.com/7a690d74f221ff9885709f5f406e9ec7)|トップページ|
|[![Image from Gyazo](https://i.gyazo.com/b4577b3d1b4e502431c72daa39a7577d.gif)](https://gyazo.com/b4577b3d1b4e502431c72daa39a7577d)|ユーザー機能<br><br>・新規登録<br>・ログイン/ログアウト<br>・マイページ（プロフィール表示・編集）|
|[![Image from Gyazo](https://i.gyazo.com/de060121fb8fd282f91f53d3ed6961d0.gif)](https://gyazo.com/de060121fb8fd282f91f53d3ed6961d0)|事前通知機能<br><br>・通知設定機能<br>・通知一覧機能<br>・通知詳細機能<br>・編集・削除機能 |
|[![Image from Gyazo](https://i.gyazo.com/a5d71b19fb65edeb7c758adb630d15c1.gif)](https://gyazo.com/a5d71b19fb65edeb7c758adb630d15c1)|リアルタイム投稿機能<br><br>・写真投稿機能<br>・一覧機能<br>・詳細機能<br>・編集・削除機能|
|[![Image from Gyazo](https://i.gyazo.com/4df9e6571b6a88c918dc972ea420234a.gif)](https://gyazo.com/4df9e6571b6a88c918dc972ea420234a)|投稿ランキング投稿機能<br><br>・一覧機能<br>・いいね機能<br>・検索機能|
|[![Image from Gyazo](https://i.gyazo.com/0c1042100d3f067e026743cf01d43a47.gif)](https://gyazo.com/0c1042100d3f067e026743cf01d43a47)|お気に入り機能<br><br>・一覧機能<br>・詳細表示機能<br>・追加・解除機能|
|[![Image from Gyazo](https://i.gyazo.com/4fef42e684a9fca3b48dee73984a494a.gif)](https://gyazo.com/4fef42e684a9fca3b48dee73984a494a)|登山ルートフィルター機能|
|[![Image from Gyazo](https://i.gyazo.com/3c3152cb9a0d5cfd85461c7ca6b2f84b.gif)](https://gyazo.com/3c3152cb9a0d5cfd85461c7ca6b2f84b)|検索機能<br><br>・地域別のエリア検索<br>・登山マップからの検索<br>・投稿の検索|

## 実装予定の機能
- 「エリア登録」  
  エリア登録＋通知設定＋カレンダー連携で1ヶ月前・1週間前に通知OK
- 「天気情報」  
  見頃×天気×登山スポットを地図で表示→グラフでピーク時期が一目でわかる
- 「いいね機能」  
  いいねした数の表示
- 「写真ランキング」  
  人気（いいね）順でチェック可能
- 「ルートフィルターの精度向上」  
  初心者向けの低山〜上級者向けの高山まで、花の種類や標高でルート検索

## データベース設計

[![Image from Gyazo](https://i.gyazo.com/b393a957421f429bb16acba643b3dc9a.png)](https://gyazo.com/b393a957421f429bb16acba643b3dc9a)


## 画面遷移図

[![Image from Gyazo](https://i.gyazo.com/32802e39a816a4af00e7e9b98c8dea4c.png)](https://gyazo.com/32802e39a816a4af00e7e9b98c8dea4c)


## 開発環境
| 項目               | バージョン・サービス |
|-------------------|-------------------|
| **言語**           | Ruby 3.2.0        |
| **フレームワーク**    | Ruby on Rails 7.1.5.1 |
| **データベース**     | PostgreSQL 14.15（本番） / MySQL 8.0（開発） |
| **フロントエンド**     | HTML / CSS / JavaScript / Bootstrap |
| **認証機能**        | Devise |
| **API連携**        | Google Maps API |
| **デプロイ環境**     | Render |
| **画像保存**       | AWS S3 |
| **バージョン管理**    | GitHub |
 
## その他
・画像アップロード ：carrierwave / MiniMagick  
・位置情報：Geocoder  
・ページネーション：Kaminari  
・テスト：RSpec

## ローカルでの動作方法

1. リポジトリをクローンします。
```ruby
  git clone https://github.com/momonst/hanayama-reminder-app-42329.git
  cd hanayama-reminder-app-42329
```

2.必要なGemをインストールします。
  ```ruby
  bundle install 
  ```
3.データベースを設定します。
  ```ruby
  rails db:create
  rails db:migrate
  rails db:seed
  ```
4.アプリケーションを起動します。
  ```ruby
  rails s
  ```
5.ブラウザで http://localhost:3000 にアクセスします。


## 工夫したポイント
花山リマインダーは、「事前準備」に特化しているので、「地域×時期×通知」の組み合わせで、花の見頃を自分が設定したタイミングで事前通知する機能をメインにしています。
<br>「手間なく見逃しを防ぐ体験」ができるを目標に、特に以下の点に工夫しました。
<br> - 簡単な画像アップロード：リアルタイムですぐにアップロードできるようシンプルにしています。
<br> - 直感的なインターフェース：操作がしやすく、初めての人でもわかりやすいデザインにしています。
<br> - 事前通知のポップアップ：リマインドに特化し、ちょっとした気づきを提供
<br> - お気に入り×通知の組合せ：ユーザーが気になる花やスポットをお気に入り＆通知設定しておけば後日リマインドされる
<br> - エリア選択：選択したエリアの花と登山スポット詳細へ自然に遷移

## 今後の課題
現在のアプリは基本的な機能を提供していますが、ユーザーのニーズに応えるために、以下の追加機能を検討しています。  
- 天気情報：年によって開花時期が変わる（気候変動の影響）
- ルート詳細情報：MAP連携の修正（標高・向きなど）
- 花山情報のデータ蓄積：ユーザー参加型で年々精度が向上する学習システム
- YAMAPの日記投稿機能との連携
- 管理者ページを作成
- Googleカレンダー連携
- いいね機能追加

## 制作時間
190時間