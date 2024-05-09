import json


with open("dummy_data.json", 'r') as f:
    config = json.load(f)

print(config)

for person in config['person']:
    print(f"Full Name: {person['name']} {person['lastname']}" )
    print(f"Age: {2024 - int(person['birthyear'])}" )
    print(f"Country: {person['country']}" )
    print("Hobbies:")
    for hobby in person['hobbies']:
        print(f"⭐ {hobby}")
    print("")
    