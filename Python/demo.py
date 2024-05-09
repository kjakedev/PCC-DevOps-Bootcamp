# name = input ("What is your name? ")
# age = input ("How old are you? ")
# # age = 3

# print("Your personal info:")
# print("Name: " + name)
# print(f"Age: {float(age) + 2}")

# if 10 > 30:
#   print("10 is greater than 30")
#   if 10 == 2:
#     print("10 is equal 2")
#   else: print("10 is not equal to 2")
# elif 10 == 30:
#   print("10 is equal to 30")
# else:
#     print("Nothing is true")
# b = 200
# a = 33

# print("A") if a > b else print("B")


# i = 1
# while i < 6:
#   print(i)
#   i += 1

# for i in "Hello World":
#     print(i + '💃', end="")

# i = 0
# while i < 6:
#     i += 1
#     # if i == 3:
#     #     continue
#     print(i)
# else:
#   print("i is no longer less than 6")

# fruits = ["apple", "banana", "cherry"]
# for x in fruits:
#   if x == "banana":
#     continue
#   print(x)
# else:
#     print("fruits are printed")
# name = ""
# age = ""
# def display_info(name="John",age="2"):
#     print("-"*20)
#     print("Your personal info")
#     print("-"*20)
#     print("Name: " + name)
#     print(f"Age: {float(age) + 2}")

# def info_getter():
#     # name = input ("What is your name? ")
#     # age = input ("How old are you? ")
#     display_info(age="4",name="Test")

# # info_getter()
# #          -3       -2          -1
# mylist = ["apple", "banana", "cherry"] # 0x3c
# #           0        1         2

# # fruits = mylist # 0x3c
# fruits = mylist[:]
# print("Fruits: ", fruits) 

# fruits[1] = "mango"
# print("Fruits after editing fruits[1]: ",fruits)
# print("MyList: ",mylist)
# fruits.pop()
# print("Fruits after pop: ", fruits) 

car =	{
  "brand": "Ford",
  "model": "Mustang",
  "year": 1964
}
car2 = {}
for key in car:
    car2[key] = car[key]
print("Car", car)
print("Car2", car2)


car["year"] = 2024
# print(car["model"]) # Mustang
# print(car.get("model")) # Mustang

print("Car", car)
print("Car2", car2)
