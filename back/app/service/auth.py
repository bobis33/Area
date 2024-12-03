from passlib.context import CryptContext
from fastapi_jwt_auth import AuthJWT
from app.database import DAO

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def login_user(email, password, Authorize: AuthJWT):
    user = await DAO.find_user_by_email(email)
    if user and pwd_context.verify(password, user['password']):
        access_token = Authorize.create_access_token(subject=email)
        return access_token
    return None

async def register_user(email, password):
    if await DAO.find_user_by_email(email):
        return None
    hashed_password = pwd_context.hash(password)
    await DAO.insert_user(email, hashed_password)
    return True
