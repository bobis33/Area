from motor.motor_asyncio import AsyncIOMotorClient
from app.config import Config

def get_database(config_class=Config):
    client = AsyncIOMotorClient(config_class.MONGO_URI)
    db = client.get_default_database()

    return db

class UserDAO:
    @staticmethod
    async def find_user_by_username(username):
        return await get_database().users.find_one({"username": username})

    @staticmethod
    async def insert_user(username, hashed_password):
        return await get_database().users.insert_one({"username": username, "password": hashed_password})
