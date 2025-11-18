import random

def generate_currencies():
    currencies = []

    currency_list = [
        ('USD', 'US Dollar'),
        ('CAD', 'Canadian Dollar'),
        ("EUR", "Euro"),
        ("GBP", "British Pound Sterling"),
        ("JPY", "Japanese Yen"),
        ("AUD", "Australian Dollar"),
        ("NZD", "New Zealand Dollar"),
        ("CHF", "Swiss Franc"),
        ("CNY", "Chinese Yuan"),
        ("INR", "Indian Rupee"),
        ("MXN", "Mexican Peso"),
        ("BRL", "Brazilian Real"),
        ("ZAR", "South African Rand"),
        ("SEK", "Swedish Krona"),
        ("NOK", "Norwegian Krone"),
        ("DKK", "Danish Krone"),
        ("HKD", "Hong Kong Dollar"),
        ("SGD", "Singapore Dollar"),
        ("KRW", "South Korean Won"),
        ("TRY", "Turkish Lira")
    ]

    for code, name in currency_list:
        currencies.append({
            'currencyCode': code,
            'fullName': name,
            'price': 1.00,
            'conversionRate': round(random.gauss(1.0,0.25), 2)
        })
    
    return currencies


def generate_exchanges():
    exchanges = []

    exchanges.append({
        'exchangeCode': 'CME',
        'exchangeName': 'Chicago Mercantile Exchange',
        'location': 'Chicago, USA',
        'description': 'Major U.S. exchange for energy, metals, agriculture, and livestock futures.',
        'currencyCode': 'USD'
    })

    exchanges.append({
        'exchangeCode': 'NYMEX',
        'exchangeName': 'New York Mercantile Exchange',
        'location': 'New York, USA',
        'description': 'Key global marketplace for crude oil, natural gas, and precious metals.',
        'currencyCode': 'USD'
    })

    exchanges.append({
        'exchangeCode': 'ICEEU',
        'exchangeName': 'Intercontinental Exchange Europe',
        'location': 'London, United Kingdom',
        'description': 'Major exchange for Brent crude oil and soft commodities such as cocoa and sugar.',
        'currencyCode': 'GBP'
    })

    exchanges.append({
        'exchangeCode': 'TOCOM',
        'exchangeName': 'Tokyo Commodity Exchange',
        'location': 'Tokyo, Japan',
        'description': 'Japan’s primary commodities exchange trading gold, rubber, and petroleum.',
        'currencyCode': 'JPY'
    })

    exchanges.append({
        'exchangeCode': 'MCX',
        'exchangeName': 'Multi Commodity Exchange of India',
        'location': 'Mumbai, India',
        'description': 'India’s largest commodity futures exchange for metals, energy, and agriculture.',
        'currencyCode': 'INR'
    })

    exchanges.append({
        'exchangeCode': 'DCE',
        'exchangeName': 'Dalian Commodity Exchange',
        'location': 'Dalian, China',
        'description': 'Large Chinese exchange focused on iron ore, soybeans, and agricultural futures.',
        'currencyCode': 'CNY'
    })

    exchanges.append({
        'exchangeCode': 'ZCE',
        'exchangeName': 'Zhengzhou Commodity Exchange',
        'location': 'Zhengzhou, China',
        'description': 'Agricultural-focused exchange specializing in wheat, cotton, and sugar.',
        'currencyCode': 'CNY'
    })

    exchanges.append({
        'exchangeCode': 'SFE',
        'exchangeName': 'Sydney Futures Exchange',
        'location': 'Sydney, Australia',
        'description': 'Australian exchange historically active in commodities and financial derivatives.',
        'currencyCode': 'AUD'
    })

    exchanges.append({
        'exchangeCode': 'SAFEX',
        'exchangeName': 'South African Futures Exchange',
        'location': 'Johannesburg, South Africa',
        'description': 'Major African commodity exchange focused on agricultural contracts like maize and wheat.',
        'currencyCode': 'ZAR'
    })

    exchanges.append({
        'exchangeCode': 'DME',
        'exchangeName': 'Dubai Mercantile Exchange',
        'location': 'Dubai, United Arab Emirates',
        'description': 'Key Middle Eastern exchange known for Oman crude oil futures.',
        'currencyCode': 'USD'  # USD used because AED not in your list
    })
    return exchanges



def generate_commodities():


    commodities = []

    commodities.append({
        'commodityCode': 'COI',
        'fullName': 'Crude Oil',
        'type': 'Energy',
        'unitOfMeasure': 'Barrel',
        'description': 'Standard intermediate crude oil benchmark traded globally.'
    })

    commodities.append({
        'commodityCode': 'BRN',
        'fullName': 'Brent Crude',
        'type': 'Energy',
        'unitOfMeasure': 'Barrel',
        'description': 'North Sea Brent crude benchmark used as a global oil price reference.'
    })

    commodities.append({
        'commodityCode': 'NGS',
        'fullName': 'Natural Gas',
        'type': 'Energy',
        'unitOfMeasure': 'MMBtu',
        'description': 'Natural gas futures contract traded heavily in energy markets.'
    })

    commodities.append({
        'commodityCode': 'GOL',
        'fullName': 'Gold',
        'type': 'Metal',
        'unitOfMeasure': 'Ounce',
        'description': '24-karat gold futures contract commonly used as a safe-haven asset.'
    })

    commodities.append({
        'commodityCode': 'SLV',
        'fullName': 'Silver',
        'type': 'Metal',
        'unitOfMeasure': 'Ounce',
        'description': 'Physical silver futures widely used in industrial and investment markets.'
    })

    commodities.append({
        'commodityCode': 'COP',
        'fullName': 'Copper',
        'type': 'Metal',
        'unitOfMeasure': 'Pound',
        'description': 'High-grade copper traded globally for industrial use.'
    })

    commodities.append({
        'commodityCode': 'WTW',
        'fullName': 'Wheat',
        'type': 'Agriculture',
        'unitOfMeasure': 'Bushel',
        'description': 'Soft red winter wheat futures contract used in food and feed markets.'
    })

    commodities.append({
        'commodityCode': 'CRN',
        'fullName': 'Corn',
        'type': 'Agriculture',
        'unitOfMeasure': 'Bushel',
        'description': 'Yellow corn futures contract used widely in agriculture and biofuel.'
    })

    commodities.append({
        'commodityCode': 'SBN',
        'fullName': 'Soybeans',
        'type': 'Agriculture',
        'unitOfMeasure': 'Bushel',
        'description': 'Soybean futures contract traded across major agricultural exchanges.'
    })

    commodities.append({
        'commodityCode': 'SUG',
        'fullName': 'Sugar',
        'type': 'Agriculture',
        'unitOfMeasure': 'Pound',
        'description': 'World Sugar No.11 futures contract used in global sugar markets.'
    })

    return commodities


