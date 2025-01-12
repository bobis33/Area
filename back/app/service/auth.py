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

    google_account = await DAO.find(get_database().google_users,
                                 "token.access_token", google_token)

    if "linked_to" not in user or user["linked_to"] is None:
        user["linked_to"] = {}

    google_account["linked_to"] = user["_id"]
    user["linked_to"]["google"] = google_account["_id"]

    await DAO.update_user(user["username"], user)
    await DAO.update(get_database().google_users, "token.access_token", google_token, google_account)

async def is_linked_google_service(token):
    user = await DAO.find_user_by_username(token)
    if user is None:
        return False
    if "google" in user["linked_to"]:
        return True

    return False

async def oauth_google_login(google_token):
    user_info = google_token.get("userinfo")
    user_account = await DAO.find(get_database().google_users, "email", user_info["email"])

    if user_account is None:
        await DAO.insert(get_database().google_users, {"email": user_info["email"], "token": google_token, "linked_to": None})

async def area_oauth_google_login(google_token):
    user_info = google_token.get("userinfo")
    if not user_info or "email" not in user_info:
        raise ValueError("Invalid Google token: missing user info")

    google_account = await DAO.find(get_database().google_users, "email", user_info["email"])
    linked_account = None

    if google_account:
        linked_to = google_account.get("linked_to")
        if linked_to:
            linked_account = await DAO.find(get_database().users, "_id", linked_to)
    else:
        google_account = {
            "email": user_info["email"],
            "token": google_token,
            "linked_to": None
        }
        await DAO.insert(get_database().google_users, google_account)
        google_account = await DAO.find(get_database().google_users, "email", user_info["email"])

    if not linked_account:
        username = NameGenerator.generate_username_from_email(user_info["email"])
        new_user = {
            "username": username,
            "password": None,
            "email": user_info["email"],
            "subscribed_areas": [],
            "created_at": datetime.datetime.now(),
            "updated_at": datetime.datetime.now(),
            "linked_to": {"google": google_account["_id"]}
        }
        await DAO.insert(get_database().users, new_user)
        linked_account = await DAO.find_user_by_username(username)

        google_account["linked_to"] = linked_account["_id"]
        await DAO.update(get_database().google_users, "email", user_info["email"], google_account)

    return linked_account["username"] if linked_account else None
