require './app/repositories/xrp_jpy_history_repository.rb'
require 'yaml'
namespace :orders do
    desc "値動きが激しい時に、リップルを自動で売り買いする"
    task :buy => :environment do
            # 最後にDB保存した時の買値を取得
            xrp_repository = Xrp_jpy_history_repository.new
            last_buy = xrp_repository.get_last_buy

            # Bitbankのライブラリをnew
            config = YAML.load_file('./config/bitbanksetting.yml')
            bbcc = Bitbankcc.new("#{config['API_KEY']}", "#{config['SECRET_KEY']}")

            # xrp_jpyの値段を取得
            ticker = bbcc.read_ticker('xrp_jpy')
            ticker_model = JSON.parse(ticker)

            # 取得したxrp_jpyの値段を保存
            xrp_repository.insert(ticker_model)
            next if last_buy.blank? #初回はDBに値がないため、処理終了

            price_difference = ticker_model["data"]["buy"].to_d - last_buy
            puts "前回との差額：#{price_difference}"

            # 前回より大きく 上がっていればbuy
            if  price_difference > 0.2
                puts "前回より大きく上がっているため、購入処理"

                balance = bbcc.read_balance
                balance_model = JSON.parse(balance)
                jpy_free_amount = balance_model["data"]["assets"].find { |a| a["asset"] == 'jpy'}["free_amount"]
                puts jpy_free_amount

                # 流動日本円の65%をxrpの値段で割って、購入数量を決める(成行注文は流動日本円70%までしか注文できない)
                buy_amount = jpy_free_amount.to_d*6.5/10 / ticker_model["data"]["buy"].to_d
                puts buy_amount

                # 購入
                order_response = bbcc.create_order('xrp_jpy', buy_amount.to_s, 0, 'buy', 'market') # market（成行）の時数字は関係なさげ　limit（成行）の時は関係ありそう
                puts order_response
                order_result = JSON.parse(order_response)

                # 注文履歴を保存
                order_repository = Order_history_repository.new
                order_repository.insert(order_result)
            end

            # 前回より大きく 下がっていればsell
            if  price_difference < -0.2
                puts "前回より大きく下がっているため、売り処理"

                balance = bbcc.read_balance
                balance_model = JSON.parse(balance)
                xrp_free_amount = balance_model["data"]["assets"].find { |a| a["asset"] == 'xrp'}["free_amount"]
                
                # 売り
                order_response = bbcc.create_order('xrp_jpy', xrp_free_amount.to_s, 0, 'sell', 'market')
                puts order_response
                order_result = JSON.parse(order_response)

                # 注文履歴を保存
                order_repository = Order_history_repository.new
                order_repository.insert(order_result)
            end

            if(price_difference).between?(-0.2, 0.2) # betweenは設定値を含む
                puts "変動が小さいため、orderなし"
            end
    end
end

# - 10000 URLが存在しません
# - 10001 システムエラーが発生しました。サポートにお問い合わせ下さい
# - 10002 不正なJSON形式です。送信内容をご確認下さい
# - 10003 システムエラーが発生しました。サポートにお問い合わせ下さい
# - 10005 タイムアウトエラーが発生しました。しばらく間をおいて再度実行して下さい
# - 20001 API認証に失敗しました
# - 20002 APIキーが不正です
# - 20003 APIキーが存在しません
# - 20004 API Nonceが存在しません
# - 20005 APIシグネチャが存在しません
# - 20011 ２段階認証に失敗しました
# - 20014 SMS認証に失敗しました
# - 30001 注文数量を指定して下さい
# - 30006 注文IDを指定して下さい
# - 30007 注文ID配列を指定して下さい
# - 30009 銘柄を指定して下さい
# - 30012 注文価格を指定して下さい
# - 30013 売買どちらかを指定して下さい
# - 30015 注文タイプを指定して下さい
# - 30016 アセット名を指定して下さい
# - 30019 uuidを指定して下さい
# - 30039 出金額を指定して下さい
# - 40001 注文数量が不正です
# - 40006 count値が不正です
# - 40007 終了時期が不正です
# - 40008 end_id値が不正です
# - 40009 from_id値が不正です
# - 40013 注文IDが不正です
# - 40014 注文ID配列が不正です
# - 40015 指定された注文が多すぎます
# - 40017 銘柄名が不正です
# - 40020 注文価格が不正です
# - 40021 売買区分が不正です
# - 40022 開始時期が不正です
# - 40024 注文タイプが不正です
# - 40025 アセット名が不正です
# - 40028 uuidが不正です
# - 40048 出金額が不正です
# - 50003 現在、このアカウントはご指定の操作を実行できない状態となっております。サポートにお問い合わせ下さい
# - 50004 現在、このアカウントは仮登録の状態となっております。アカウント登録完了後、再度お試し下さい
# - 50005 現在、このアカウントはロックされております。サポートにお問い合わせ下さい
# - 50006 現在、このアカウントはロックされております。サポートにお問い合わせ下さい
# - 50008 ユーザの本人確認が完了していません
# - 50009 ご指定の注文は存在しません
# - 50010 ご指定の注文はキャンセルできません
# - 50011 APIが見つかりません
# - 50026 ご指定の注文は既にキャンセル済みです
# - 50027 ご指定の注文は既に約定済みです
# - 60001 保有数量が不足しています
# - 60002 成行買い注文の数量上限を上回っています
# - 60003 指定した数量が制限を超えています
# - 60004 指定した数量がしきい値を下回っています
# - 60005 指定した価格が上限を上回っています
# - 60006 指定した価格が下限を下回っています
# - 60011 同時発注制限件数(30件)を上回っています
# - 70001 システムエラーが発生しました。サポートにお問い合わせ下さい
# - 70002 システムエラーが発生しました。サポートにお問い合わせ下さい
# - 70003 システムエラーが発生しました。サポートにお問い合わせ下さい
# - 70004 現在取引停止中のため、注文を承ることができません
# - 70005 現在買注文停止中のため、注文を承ることができません
# - 70006 現在売注文停止中のため、注文を承ることができません
# - 70009 ただいま成行注文を一時的に制限しています。指値注文をご利用ください。
# - 70010 ただいまシステム負荷が高まっているため、最小注文数量を一時的に引き上げています。
# - 70011 ただいまリクエストが混雑してます。しばらく時間を空けてから再度リクエストをお願いします
