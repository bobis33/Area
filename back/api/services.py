from passlib.context import CryptContext
from fastapi_jwt_auth import AuthJWT
from dao import UserDAO

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def login_user(username, password, Authorize: AuthJWT):
    user = await UserDAO.find_user_by_username(username)
    if user and pwd_context.verify(password, user['password']):
        access_token = Authorize.create_access_token(subject=username)
        return access_token
    return None

async def register_user(username, password):
    if await UserDAO.find_user_by_username(username):
        return None
    hashed_password = pwd_context.hash(password)
    await UserDAO.insert_user(username, hashed_password)
    return True
