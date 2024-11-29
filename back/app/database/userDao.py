from motor.motor_asyncio import AsyncIOMotorClient
from app.config import Config

def get_database(config_class=Config):
    client = AsyncIOMotorClient(config_class.MONGO_URI)
    db = client.get_default_database()

    return db

class UserDAO:
    @staticmethod
    async def insert_user(email, hashed_password):
        return await get_database().users.insert_one({"email": email, "password": hashed_password})

    @staticmethod
    async def find_user_by_email(email):
        return await get_database().users.find_one({"email": email})

    @staticmethod
    async def delete_user_by_email(email):
        return await get_database().users.delete_one({"email": email})
