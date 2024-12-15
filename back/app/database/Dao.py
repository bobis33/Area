from motor.motor_asyncio import AsyncIOMotorClient
from app.config import Config
from bson import ObjectId
import datetime

def get_database(config_class=Config):
    client = AsyncIOMotorClient(config_class.MONGO_URI)
    db = client.get_default_database()

    return db

class DAO:
    @staticmethod
    def serialize_document(doc):
        """
        Recursively converts ObjectId to string in a MongoDB document.
        """
        if isinstance(doc, dict):
            for key, value in doc.items():
                if isinstance(value, ObjectId):
                    doc[key] = str(value)
                elif isinstance(value, (dict, list)):
                    doc[key] = DAO.serialize_document(value)
        elif isinstance(doc, list):
            return [DAO.serialize_document(item) for item in doc]
        return doc


    # User management

    @staticmethod
    async def insert_user(username, hashed_password):
        return await get_database().users.insert_one({"username": username, "password": hashed_password, "email": "", "subscribed_areas": [],
                                                      "created_at": datetime.datetime.now(), "updated_at": datetime.datetime.now(),
                                                      "external_tokens": {}})

    @staticmethod
    async def update_user(username, updated_user):
        updated_user["updated_at"] = datetime.datetime.now()
        return await get_database().users.update_one({"username": username}, {"$set": updated_user})

    @staticmethod
    async def find_all_users():
        return await get_database().users.find({}).to_list(length=None)

    @staticmethod
    async def find_user_by_email(email):
        return await get_database().users.find_one({"email": username})

    @staticmethod
    async def find_user_by_username(username):
        return await get_database().users.find_one({"username": username})

    @staticmethod
    async def delete_user_by_username(username):
        return await get_database().users.delete_one({"username": username})


    # Areas
    @staticmethod
    async def insert_area(area):
        return await get_database().areas.insert_one(area)

    @staticmethod
    async def update_area(_id, updated_area):
        return await get_database().areas.update_one({"_id": ObjectId(_id)}, {"$set": updated_area})

    @staticmethod
    async def find_area_by_id(_id):
        return await get_database().areas.find_one({"_id": ObjectId(_id)})

    @staticmethod
    async def delete_area_by_id(_id):
        return await get_database().areas.delete_one({"_id": ObjectId(_id)})

    @staticmethod
    async def find_all_areas():
        documents = await get_database().areas.find({}).to_list(length=None)
        return [DAO.serialize_document(doc) for doc in documents]
