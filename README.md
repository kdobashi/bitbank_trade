# README

## 概要
bitbankで自動で売買を行う。
## 使用方法
bitbanksetting.ymlにて自身のAPI_KEYとSECRET_KEYを設定する。
Herokuにデプロイ、Heroku PostgresのDBを構築する。
Heroku Schedulerを使用して、10分毎に"rake orders:buy"を実行する想定。
※ 使用する場合は、自己責任です。