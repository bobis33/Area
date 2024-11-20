from extensions import mongo

class UserDAO:
    @staticmethod
    def find_user_by_username(username):
        return mongo.db.users.find_one({"username": username})

    @staticmethod
    def insert_user(username, hashed_password):
        return mongo.db.users.insert_one({"username": username, "password": hashed_password})
