import random
from datetime import timedelta, date
from basic_generation import generate_commodities, generate_exchanges
from user_generation import generate_users
import pprint

def daterange(start, end):
    cur = start
    while cur <= end:
        yield cur
        cur += timedelta(days=1)



def assign_preferred_exchanges(users, exchanges):
    exchange_codes = [e["exchangeCode"] for e in exchanges]
    preferred = {}

    for u in users:
        uid = u["userID"]  # your user objects are dicts
        k = random.randint(1, 3)  # each user chooses 1–3 exchanges
        preferred[uid] = random.sample(exchange_codes, k)

    return preferred



def generate_transaction_for_date(users, commodities, exchanges, positions, tx_date, preferred_exchanges):

    # Pick random trader
    user = random.choice(users)
    user_id = user["userID"]

    # Pick commodity
    commodity = random.choice(commodities)
    commodity_code = commodity["commodityCode"]

    # Pick exchange only from user's preferred list
    exchange_code = random.choice(preferred_exchanges[user_id])

    # Track position key
    key = (user_id, commodity_code, exchange_code)
    current_pos = positions.get(key, 0)

    # Buy/Sell respecting inventory
    if current_pos <= 0:
        buy_sell = "Buy"
    else:
        buy_sell = random.choice(["Buy", "Sell"])

    # Quantity
    quantity = random.randint(50, 5000)

    # Adjust sells to available quantity
    if buy_sell == "Sell":
        quantity = min(quantity, current_pos)
    if quantity == 0:
        return None

    # Contract month = +1 month
    contract_month_date = tx_date.replace(day=1) + timedelta(days=30)
    contract_month = contract_month_date.strftime("%b%Y").upper()

    # Update in-memory position
    if buy_sell == "Buy":
        positions[key] = current_pos + quantity
    else:
        positions[key] = current_pos - quantity

    return {
        "transactionDate": tx_date,
        "contractMonth": contract_month,
        "buySell": buy_sell,
        "quantity": quantity,
        "userID": user_id,
        "commodityCode": commodity_code,
        "exchangeCode": exchange_code,
        "priceDate": tx_date
    }



def generate_transactions(users, start, end):

    positions = {}
    commodities = generate_commodities()
    exchanges = generate_exchanges()

    # Build preferred exchange map
    preferred_exchanges = assign_preferred_exchanges(users, exchanges)

    transactions = []

    for tx_date in daterange(start, end):
        for _ in range(100):
            tx = generate_transaction_for_date(
                users,
                commodities,
                exchanges,
                positions,
                tx_date,
                preferred_exchanges
            )

            if tx:
                transactions.append(tx)
    
    return transactions


if __name__ == '__main__':
    users = generate_users()  # list of user dicts
    transactions = generate_transactions(users, date(2023,1,1), date(2025,11,1))

    print("Example transaction:")
    pprint.pprint(transactions[:5])
    print("Total transactions:", len(transactions))
