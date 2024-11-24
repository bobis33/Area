from extensions import db

class UserDAO:
    @staticmethod
    async def find_user_by_username(username):
        return await db.users.find_one({"username": username})

    @staticmethod
    async def insert_user(username, hashed_password):
        return await db.users.insert_one({"username": username, "password": hashed_password})
