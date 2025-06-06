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
花山リマインダー

## アプリケーション概要
「花山リマインダー」は、毎月、自分の行くエリアの「今見頃の花＆山」を通知でお知らせ、見逃し防止
開花前からリマインドしてくれるので計画が立てやすい
写真投稿やお気に入り保存もできるから、モチベアップ！新しい発見あり！
働き盛りの「20~30代女性ハイカー（登山好き）」必見アプリケーションです。
<br>ユーザーはエリアを登録しておけば、簡単に見頃の花の情報とそのお花が見れる登山スポットを事前に通してしてくれます。詳細画面では画像やマップ、開花予測などが閲覧できます。

## URL
https://◎◎◎◎.onrender.com
<br>※デプロイ済みのURLを記載。デプロイが済んでいない場合は、デプロイが完了次第記載すること。

## テスト用アカウント
テスト用Email：test@test.com
<br>テスト用Password：aaa123
<br>※ログイン機能等を実装した場合は、ログインに必要な情報を記載。
<br>※またBasic認証等を設けている場合は、そのID/Passも記載すること。

## 利用方法
1. URLにアクセスし、ヘッダー右上の「ログイン」ボタンからログイン画面に移動します。
2. テスト用アカウントを使用しログインします。
3. トップページのヘッダー右上の「投稿する」ボタンから新規呟きを投稿します。
4. 投稿内容には画像1枚と文章を含めることができます。
5. 他のユーザーの呟きを閲覧し、コメントを残すことも可能です。
6. 投稿した呟きはトップページから編集・削除できます。

## アプリケーションを作成した背景
花の見頃は短く、場所によって時期が大きく違うため、見逃しやすいという声が多い。
特に仕事で忙しいユーザーは、登山計画と花のタイミングを合わせづらい。
さらに、既存サービスでは「地域とタイミングで絞り込んで通知する」機能が少なく、ニーズに応える価値があると判断したため。
<br>写真投稿やお気に入り保存もできるから、新しい発見もあり、登山に行くきっかけになるリマインダーを目指します。

## 実装した機能についての画像やGIFおよびその説明
|ページ|説明|
|---|------------------|
|![トップページのGIF](URL_TO_GIF)|トップページ　　　　　　　　　　　　　　　　　　　　　　|
|![ユーザー機能のGIF](URL_TO_GIF)|ユーザー機能<br>・新規登録<br>・ログイン/ログアウト<br>・マイページ|
|![ツイート機能のGIF](URL_TO_GIF)|ツイート（呟き）機能<br>・投稿機能<br>・一覧機能<br>・詳細機能<br>・編集・削除機能|
|![コメント機能のGIF](URL_TO_GIF)|コメント機能|
|![検索機能のGIF](URL_TO_GIF)|検索機能|

## 実装予定の機能
- 「開花リマインダー」  
  エリア登録＋月毎に通知→カレンダー連携で1ヶ月前・1週間前に通知OK
- 「花登山マップ」  
  見頃×天気×登山スポットを地図で表示→グラフでピーク時期が一目でわかる
- 「お気に入り保存」  
  気になる花・ルートを保存し、見頃前に通知
- 「リアル投稿 × 写真ランキング」  
  行った人の写真を人気順・最新順でチェック可能
- 「ルートフィルター」  
  初心者向けの低山〜上級者向けの高山まで、花の種類や標高でルート検索OK

## データベース設計
ER図を添付。
<br>AIで作る場合は、googleアカウントがあれば使用できる「Vercel v0」がオススメです。
<img width="307" alt="Image" src="https://github.com/user-attachments/assets/f780ed7f-e22c-495f-ad7d-5add7f75e45f" />


## 画面遷移図
画面遷移図を添付。
<br>AIで作る場合は、googleアカウントがあれば使用できる「Vercel v0」がオススメです。
<img width="509" alt="Image" src="https://github.com/user-attachments/assets/086ceb82-5286-4340-b4ff-014d621e4d26" />


## 開発環境
| 項目               | バージョン・サービス |
|------------------|-----------------|
| **言語**        | Ruby 3.2.0 |
| **フレームワーク** | Ruby on Rails 7.1.5.1 |
| **データベース**  | PostgreSQL 14.15（本番） / MySQL 8.0（開発） |
| **フロントエンド** | HTML / CSS / JavaScript |
| **認証機能**    | Devise |
| **デプロイ環境** | Render |
| **バージョン管理** | GitHub |

## ローカルでの動作方法

1. リポジトリをクローンします。
```ruby
  git clone https://github.com/GitHubのユーザー名/アプリ名
```

2.必要なGemをインストールします。
  ```ruby
  bundle install 
  ```
3.データベースを設定します。
  ```ruby
  rails db:create
  rails db:migrate
  ```
4.アプリケーションを起動します。
  ```ruby
  rails s
  ```
5.ブラウザで http://localhost:3000 にアクセスします。


## 工夫したポイント
花山リマインダーは、事前準備に特化しているので、「地域×時期×通知」の組み合わせで、花の見頃を事前通知する機能をメインにポップアップ表示できるようにしています。
<br>「手間なく見逃しを防ぐ体験」ができるを目標に、特に以下の点に工夫しました。
<br> - 簡単な画像アップロード：投稿の際に画像をすぐにアップロードできます。
<br> - 直感的なインターフェース：操作がしやすく、初めての人でもわかりやすいデザインにしています。
<br> - 事前通知のポップアップ：リマインドに特化し、気づきを提供
<br> - お気に入り×通知の組合せ：ユーザーが気になる花やスポットをお気に入り＆通知設定しておけば後日リマインドされる
<br> - 花登山マップ：マップ画面から花とスポット詳細を自然に遷移


## 今後の課題
現在のアプリは基本的な機能を提供していますが、ユーザーのニーズに応えるために、以下の追加機能を検討しています。  
現状の設計では花の開花情報が「固定データ」
- 年によって開花時期が変わる（気候変動の影響）
- 場所によって微妙に時期が違う（標高・向きなど）
- リアルタイムの開花状況が最も価値があるのにAPI連携できる情報元は制限されている
<br>管理者権限を作成する

解決策として、、
💡 ユーザー参加型データ収集の仕組みと価値
「写真投稿機能」と開花予測の自動更新によるアップデート
1. リアルタイム性 - 最新の開花状況
2. 精度向上 - 複数ユーザーの報告で信頼性UP
3. コミュニティ形成 - 登山者同士の情報共有
4. データ蓄積 - 年々精度が向上する学習システム
<br>単なる情報アプリから登山者コミュニティのプラットフォームに進化予定<br>

<br>コメント機能の編集・削除：投稿したコメントの内容を変更したり、削除できるようにします。
<br>画像の複数アップロード：複数の画像を一度に投稿できる機能を追加します。

## 制作時間
80時間