import datetime
import aiohttp

from passlib.context import CryptContext
from fastapi_jwt_auth import AuthJWT
from fastapi import APIRouter, Depends, HTTPException, status

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

async def oauth_discord_login(discord_token):
    async with aiohttp.ClientSession() as session:
        async with session.get('https://discord.com/api/users/@me', headers={'Authorization': f'Bearer {discord_token["access_token"]}'}) as response:
            user_info = await response.json()
            if not user_info:
                raise RuntimeError("Failed to retrieve user info from Discord")

            discord_username = user_info.get("username")
            if not discord_username:
                raise RuntimeError("Discord username not found in user info")

            user_email = user_info.get("email")
            if not user_email:
                raise RuntimeError("Email not found in user info")

    user_account = await DAO.find(get_database().discord_users, "email", user_email)

    if not user_account:
        await DAO.insert(get_database().discord_users, {"email": user_info.get("email"), "user_info": user_info, "token": discord_token, "linked_to": None})

async def area_oauth_discord_login(discord_token):
    async with aiohttp.ClientSession() as session:
        async with session.get('https://discord.com/api/users/@me', headers={'Authorization': f'Bearer {discord_token["access_token"]}'}) as response:
            user_info = await response.json()
            if not user_info:
                raise RuntimeError("Failed to retrieve user info from Discord")

            discord_username = user_info.get("username")
            if not discord_username:
                raise RuntimeError("Discord username not found in user info")

            user_email = user_info.get("email")
            if not user_email:
                raise RuntimeError("Email not found in user info")

    discord_account = await DAO.find(get_database().discord_users, "email", user_email)
    linked_account = None

    if discord_account is None:
        await DAO.insert(get_database().discord_users, {"email": user_info.get("email"), "user_info": user_info, "token": discord_token, "linked_to": None})
        discord_account = await DAO.find(get_database().discord_users, "email", user_info.get("email"))

    elif discord_account["linked_to"] is not None:
        linked_account = await DAO.find(get_database().users, "_id", discord_account["linked_to"])

    if linked_account is None:
        username = NameGenerator.generate_username_from_email(user_info["email"])
        await DAO.insert(get_database().users, {"username": username, "password": None, "email": user_info["email"], "subscribed_areas": [],
                                                      "created_at": datetime.datetime.now(), "updated_at": datetime.datetime.now(),
                                                      "linked_to": {"discord" : discord_account["_id"]}})
        linked_account = await DAO.find_user_by_username(username)
        discord_account["linked_to"] = linked_account["_id"]
        await DAO.update(get_database().discord_users, "email", user_info["email"], discord_account)

    return linked_account["username"]

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

    elif google_account["linked_to"] != None:
        linked_account = await DAO.find(get_database().users, "_id", google_account["linked_to"])

    if linked_account is None:
        username = NameGenerator.generate_username_from_email(user_info["email"])
        await DAO.insert(get_database().users, {"username": username, "password": None, "email": user_info["email"], "subscribed_areas": [],
                                                      "created_at": datetime.datetime.now(), "updated_at": datetime.datetime.now(),
                                                      "linked_to": {"google" : google_account["_id"]}})
        linked_account = await DAO.find_user_by_username(username)
        google_account["linked_to"] = linked_account["_id"]
        await DAO.update(get_database().google_users, "email", user_info["email"], google_account)


    return linked_account["username"]

async def link_to_discord(username, discord_token):
    user = await DAO.find_user_by_username(username)

    if user is None:
        raise RuntimeError("Couldn't find user")

    discord_user = await DAO.find(get_database().discord_users,
                                 "email", discord_token.get("userinfo")["email"])

    discord_user["link_to"] = user["_id"]
    user["link_to"]["google"] = discord_user["_id"]

    DAO.update_user(user["username"], user)
    DAO.update(get_database().discord_users,
               "email", discord_token.get("userinfo")["email"], discord_user)

async def link_to_spotify(username, spotify_token):
    user = await DAO.find_user_by_username(username)

    if user is None:
        raise RuntimeError("Couldn't find user")

    spotify_user = await DAO.find(get_database().spotify_users,
                                 "email", spotify_token.get("userinfo")["email"])

    spotify_user["link_to"] = user["_id"]
    user["link_to"]["google"] = spotify_user["_id"]

    DAO.update_user(user["username"], user)
    DAO.update(get_database().spotify_users,
               "email", spotify_token.get("userinfo")["email"], spotify_user)

async def link_to_github(username, github_token):
    user = await DAO.find_user_by_username(username)

    if user is None:
        raise RuntimeError("Couldn't find user")

    github_user = await DAO.find(get_database().github_users,
                                 "email", github_token["userinfo"]["email"])

    github_user["link_to"] = user["_id"]
    user["link_to"]["github"] = github_user["_id"]

    DAO.update_user(user["username"], user)
    DAO.update(get_database().github_users,
               "email", github_token.get("userinfo")["email"], github_user)

async def oauth_spotify_login(spotify_token):
    async with aiohttp.ClientSession() as session:
        async with session.get('https://api.spotify.com/v1/me', headers={'Authorization': f'Bearer {spotify_token["access_token"]}'}) as response:
            user_info = await response.json()
            if not user_info:
                raise RuntimeError("Failed to retrieve user info from Spotify")

            spotify_username = user_info.get("display_name")
            if not spotify_username:
                raise RuntimeError("Spotify username not found in user info")

            user_email = user_info.get("email")
            if not user_email:
                raise RuntimeError("Email not found in user info")

    user_account = await DAO.find(get_database().spotify_users, "email", user_email)

    if not user_account:
        await DAO.insert(get_database().spotify_users, {"email": user_info.get("email"), "user_info": user_info, "token": spotify_token, "linked_to": None})

async def area_oauth_spotify_login(spotify_token):
    async with aiohttp.ClientSession() as session:
        async with session.get('https://api.spotify.com/v1/me', headers={'Authorization': f'Bearer {spotify_token["access_token"]}'}) as response:
            user_info = await response.json()
            if not user_info:
                raise RuntimeError("Failed to retrieve user info from spotify")

            spotify_username = user_info.get("display_name")
            if not spotify_username:
                raise RuntimeError("spotify username not found in user info")

            user_email = user_info.get("email")
            if not user_email:
                raise RuntimeError("Email not found in user info")

    spotify_account = await DAO.find(get_database().spotify_users, "email", user_email)
    linked_account = None

    if spotify_account is None:
        await DAO.insert(get_database().spotify_users, {"email": user_info.get("email"), "user_info": user_info, "token": spotify_token, "linked_to": None})
        spotify_account = await DAO.find(get_database().spotify_users, "email", user_info.get("email"))

    elif spotify_account["linked_to"] is not None:
        linked_account = await DAO.find(get_database().users, "_id", spotify_account["linked_to"])

    if linked_account is None:
        username = NameGenerator.generate_username_from_email(user_info["email"])
        await DAO.insert(get_database().users, {"username": username, "password": None, "email": user_info["email"], "subscribed_areas": [],
                                                      "created_at": datetime.datetime.now(), "updated_at": datetime.datetime.now(),
                                                      "linked_to": {"spotify" : spotify_account["_id"]}})
        linked_account = await DAO.find_user_by_username(username)
        spotify_account["linked_to"] = linked_account["_id"]
        await DAO.update(get_database().spotify_users, "email", user_info["email"], spotify_account)

    return linked_account["username"]

async def oauth_github_login(github_token):
    async with aiohttp.ClientSession() as session:
        async with session.get('https://api.github.com/user', headers={'Authorization': f'Bearer {github_token["access_token"]}'}) as response:
            user_info = await response.json()
            if not user_info:
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Failed to retrieve user info from GitHub")

            async with session.get('https://api.github.com/user/emails', headers={'Authorization': f'Bearer {github_token["access_token"]}'}) as email_response:
                emails = await email_response.json()
                user_email = next((email["email"] for email in emails if email["primary"]), None)
                if not user_email:
                    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email not found in user info")

    user_account = await DAO.find(get_database().github_users, "email", user_email)
    if not user_account:
        await DAO.insert(get_database().github_users, {"email": user_info.get("email"), "user_info": user_info, "token": github_token, "linked_to": None})

async def is_linked_google_service(token):
    user = await DAO.find_user_by_username(token)
    if user is None:
        return False
    if "google" in user["linked_to"]:
        return True

    return False
