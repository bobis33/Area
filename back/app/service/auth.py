from passlib.context import CryptContext
from fastapi_jwt_auth import AuthJWT
from app.database import DAO

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def login_user(username, password, authorize: AuthJWT):
    user = await DAO.find_user_by_username(username)
    if user and pwd_context.verify(password, user['password']):
        access_token = authorize.create_access_token(subject=username)
        return access_token
    return None

async def register_user(username, password):
    if await DAO.find_user_by_username(username):
        return None
    hashed_password = pwd_context.hash(password)
    await DAO.insert_user(username, hashed_password)
    return True
