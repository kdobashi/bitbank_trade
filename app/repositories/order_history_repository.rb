class Order_history_repository
    def insert(order_result)
        order_history = OrderHistory.new
        order_history.order_id = order_result["data"]["order_id"]
        order_history.pair = order_result["data"]["pair"]
        order_history.side = order_result["data"]["side"]
        order_history.type = order_result["data"]["type"]
        order_history.start_amount = order_result["data"]["start_amount"]
        order_history.remaining_amount = order_result["data"]["remaining_amount"]
        order_history.executed_amount = order_result["data"]["executed_amount"]
        order_history.average_price = order_result["data"]["average_price"]
        order_history.ordered_at = order_result["data"]["ordered_at"]
        order_history.status = order_result["data"]["status"]
        order_history.save
    end
end