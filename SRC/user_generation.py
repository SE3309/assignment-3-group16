import random
from datetime import date, timedelta

def generate_users():
    first_names = [
        "Liam","Noah","Oliver","Elijah","James","William","Benjamin","Lucas","Henry","Theodore",
        "Emma","Olivia","Ava","Sophia","Isabella","Charlotte","Mia","Amelia","Harper","Evelyn"
    ]

    last_names = [
        "Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis","Rodriguez","Martinez",
        "Hernandez","Lopez","Gonzalez","Wilson","Anderson","Thomas","Taylor","Moore","Jackson","Martin"
    ]

    roles = ['Trader', 'Admin', 'Analyst']

    def random_date(start, end):
        """
        start and end are datetime.date or datetime.datetime
        """
        delta = end - start
        random_days = random.randrange(delta.days + 1)
        return start + timedelta(days=random_days)



    def random_name(email_list):
        first = random.choice(first_names)
        last = random.choice(last_names)
        role = random.choice(roles)

        email_base = first.lower()[0] + last.lower()
        email = email_base + "@company.com"
        counter = 1
        while email in email_list:
            email = email_base+str(counter) + "@company.com"
            counter+=1

        created_date = random_date(date(2023, 1,1), date(2025,11,1))
        last_login = random_date(created_date, date(2025,11,1))

        return {"firstName": first, "lastName": last, "email": email, "role": role, "createdDate": created_date, "lastLogin": last_login}

    users = []
    email_list = []
    for i in range(1000):
        user = random_name(email_list)
        email_list.append(user["email"])
        users.append(user)

    return users

