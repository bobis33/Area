import datetime

from passlib.context import CryptContext
from fastapi_jwt_auth import AuthJWT

from app.database import DAO, get_database
from app.common import NameGenerator

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

async def link_to_google(username, google_token):
    user = await DAO.find_user_by_username(username)

    if user is None:
        raise RuntimeError("Couldn't find user")

    google_user = await DAO.find(get_database().google_users,
                                 "email", google_token.get("userinfo")["email"])

    google_user["link_to"] = user["_id"]
    user["link_to"]["google"] = google_user["_id"]

    DAO.update_user(user["username"], user)
    DAO.update(get_database().google_users,
               "email", google_token.get("userinfo")["email"], google_user)

async def oauth_google_login(google_token):
    user_info = google_token.get("userinfo")
    user_account = await DAO.find(get_database().google_users, "email", user_info["email"])

    if user_account is None:
        await DAO.insert(get_database().google_users, {"email": user_info["email"], "token": google_token, "link_to": None})

async def area_oauth_google_login(google_token):
    user_info = google_token.get("userinfo")

    google_account = await DAO.find(get_database().google_users, "email", user_info["email"])
    linked_account = None

    if google_account is None:
        await DAO.insert(get_database().google_users, {"email": user_info["email"], "token": google_token, "linked_to": None})
        google_account = await DAO.find(get_database().google_users, "email", user_info["email"])

    elif "google" in google_account["linked_to"]:
        linked_account = await DAO.find(get_database().users, "_id", google_account["linked_to"]["google"])

    if linked_account is None:
        username = NameGenerator.generate_username_from_email(user_info["email"])
        await DAO.insert(get_database().users, {"username": username, "password": None, "email": user_info["email"], "subscribed_areas": [],
                                                      "created_at": datetime.datetime.now(), "updated_at": datetime.datetime.now(),
                                                      "linked_to": {"google" : google_account["_id"]}})
        linked_account = await DAO.find_user_by_username(username)
        google_account["linked_to"] = linked_account["_id"]
        await DAO.update(get_database().google_users, "email", user_info["email"], google_account)

    return linked_account.username
