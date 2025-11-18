import random
from datetime import date, timedelta
import math
import pprint

def simulate_prices_for_commodity(commodity, exchange_location, start_price, volatility, daily_volume, years=3):
    prices = []
    
    # Start at 3 years ago
    days = years * 365
    start_date = date.today() - timedelta(days=days)
    
    current_price = start_price
    
    for i in range(days):
        current_date = start_date + timedelta(days=i)

        # Price simulation (GBM)
        drift = 0.0002  # tiny upward drift
        shock = random.normalvariate(0, 1)
        current_price = current_price * math.exp((drift - 0.5 * volatility**2) + volatility * shock)
        current_price = round(current_price, 2)

        # Bid/Ask spread
        bid = round(current_price - random.uniform(0.05, 0.50), 2)
        ask = round(current_price + random.uniform(0.05, 0.50), 2)

        # Volume variation (applies to all 3 contract months)
        volume = int(daily_volume * random.uniform(0.9, 1.1))

        # Generate ALL 3 contract months (1, 2, and 3 months ahead)
        for month_ahead in [1]:

            contract_year = current_date.year
            contract_month = current_date.month + month_ahead

            if contract_month > 12:
                contract_month -= 12
                contract_year += 1

            contract_month_str = f"{date(contract_year, contract_month, 1):%b%Y}".upper()

            prices.append({
                "priceDate": current_date,
                "contractMonth": contract_month_str,
                "settlementPrice": current_price,
                "bidPrice": bid,
                "askPrice": ask,
                "volume": volume,
                "source": "Simulated Feed",
                "commodityCode": commodity,
                "exchange_location": exchange_location
            })
    
    return prices




def simulate_all_prices():
    commodity_names = [
        "crude oil",
        "brent crude",
        "natural gas",
        "gold",
        "silver",
        "copper",
        "wheat",
        "corn",
        "soybeans",
        "sugar"
    ]


    exchange_cities = [
        "chicago",
        "new york",
        "london",
        "tokyo",
        "mumbai",
        "dalian",
        "zhengzhou",
        "sydney",
        "johannesburg",
        "dubai"
    ]

    all_prices = []
    for c_name in commodity_names:
        for exchange_city in exchange_cities:
            start_price = round(random.random()*100,2)
            volatility = random.uniform(0.001,0.09)
            volume = random.randint(100,10000)
            prices = simulate_prices_for_commodity(
                commodity=c_name,
                exchange_location=exchange_city,
                start_price=start_price,     # oil base price
                volatility=volatility,    # daily volatility
                daily_volume=volume   # base volume
            )

            all_prices.extend(prices)

    return all_prices

if __name__ == '__main__':
    prices = simulate_all_prices()
    pprint.pprint(prices)