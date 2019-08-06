class Xrp_jpy_history_repository
    def insert(ticker_model)
        puts "insert"
       # 取得したxrp_jpyの値段を保存
       xrp_jpy_history = XrpJpyHistory.new
       xrp_jpy_history.sell = ticker_model["data"]["sell"]
       xrp_jpy_history.buy = ticker_model["data"]["buy"]
       xrp_jpy_history.high = ticker_model["data"]["high"]
       xrp_jpy_history.low = ticker_model["data"]["low"]
       xrp_jpy_history.last = ticker_model["data"]["last"]
       xrp_jpy_history.vol = ticker_model["data"]["vol"]
       xrp_jpy_history.access_time = ticker_model["data"]["timestamp"]
       xrp_jpy_history.save 
    end

    def get_last_buy
        begin
            last_buy = XrpJpyHistory.last[:buy]
            
        rescue => e
            p e.message
        end
            puts "前回のリップルの価格：#{last_buy}"
        return last_buy
    end
end