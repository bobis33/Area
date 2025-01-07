# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from authlib.integrations.starlette_client import OAuth
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from starlette.requests import Request
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from fastapi.responses import RedirectResponse

import datetime

from app.service import login_user, register_user
from app.config import Config
from app.database import DAO, get_database

from app.common import secure_endpoint, TokenManager, NameGenerator


router = APIRouter()
auth_scheme = HTTPBearer()

oauth = OAuth()
oauth.register(
    name = 'google',
    client_id = Config.GOOGLE_CLIENT_ID,
    client_secret = Config.GOOGLE_CLIENT_SECRET,
    server_metadata_url = Config.GOOGLE_SERVER_METADATA_URL,
    client_kwargs = Config.GOOGLE_CLIENT_KWARGS
)

class Credentials(BaseModel):
    username: str
    password: str


# User login and registration
@router.post('/login', response_model=dict)
async def login(credentials: Credentials, authorize: AuthJWT = Depends()):
    access_token = await login_user(credentials.username, credentials.password, authorize)
    if access_token:
        return {"token": access_token}

    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid username or password")

@router.post('/register', response_model=dict)
async def register(credentials: Credentials, authorize: AuthJWT = Depends()):
    if await register_user(credentials.username, credentials.password):
        access_token = await login_user(credentials.username, credentials.password, authorize)
        return {"token": access_token}

    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="username already exists")

@router.post('/link/google')
@secure_endpoint
async def link_google(google_token, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    user = await DAO.find_user_by_username(username)

    if user is None:
        raise HTTPException(status_code=404, detail="User not found")

    google_user = await DAO.find(get_database().google_users, "email", google_token.get("userinfo")["email"])

    google_user["link_to"] = user["_id"]
    user["link_to"]["google"] = google_user["_id"]

    DAO.update_user(user["username"], user)
    DAO.update(get_database().google_users, "email", google_token.get("userinfo")["email"], google_user)

    return {"message": "Google account linked successfully"}

@router.get("/login/to/google")
async def get_google_token(request: Request):
    redirect_uri = request.url_for('google_token_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri, access_type="offline", prompt="consent")

@router.get("/login/to/google/callback", include_in_schema=False)
async def google_token_callback(request: Request):
    try:
        google_token = await oauth.google.authorize_access_token(request)
        user_info = google_token.get("userinfo")
        user_account = await DAO.find(get_database().google_users, "email", user_info["email"])

        if user_account is None:
            user_account = await DAO.insert(get_database().google_users, {"email": user_info["email"], "token": google_token, "link_to": None})

        return RedirectResponse(f"{Config.FRONTEND_URL}/?google_token={google_token}")
    except Exception as e:
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

# Google OAuth
@router.get("/login/with/google")
async def login_google(request: Request):
    redirect_uri = request.url_for('google_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri, access_type="offline", prompt="consent")

@router.get("/login/with/google/callback", include_in_schema=False)
async def google_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        google_token = await oauth.google.authorize_access_token(request)
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

        access_token = authorize.create_access_token(subject=linked_account.username)

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={access_token}")
    except Exception as e:
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

@router.get('/me', response_model=dict)
@secure_endpoint
async def is_login(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    return {"detail": "Connected"}
