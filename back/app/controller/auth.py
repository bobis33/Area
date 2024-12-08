# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from fastapi.security import HTTPBearer
from starlette.requests import Request
from fastapi_jwt_auth import AuthJWT
import requests

from app.service import login_user, register_user
from app.config import Config


router = APIRouter()
auth_scheme = HTTPBearer()

class Credentials(BaseModel):
    email: str
    password: str


# User login and registration
@router.post('/login', response_model=dict)
async def login(credentials: Credentials, authorize: AuthJWT = Depends()):
    access_token = await login_user(credentials.email, credentials.password, authorize)
    if access_token:
        return {"token": access_token}

    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid email or password")

@router.post('/register', response_model=dict)
async def register(credentials: Credentials, authorize: AuthJWT = Depends()):
    if await register_user(credentials.email, credentials.password):
        access_token = await login_user(credentials.email, credentials.password, authorize)
        return {"token": access_token}

    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="email already exists")


# Google OAuth
GOOGLE_AUTHORIZATION_URL = "https://accounts.google.com/o/oauth2/v2/auth"
GOOGLE_REDIRECT_URI = "http://localhost:5000/auth/google/callback"
GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo"

@router.get("/login/google")
async def login_google(token=Depends(auth_scheme)):
    params = {
        "client_id": Config.GOOGLE_CLIENT_ID,
        "redirect_uri": GOOGLE_REDIRECT_URI,
        "response_type": "code",
        "scope": "openid email profile",
        "access_type": "offline",
        "prompt": "consent"
    }
    authorization_url = requests.Request('GET', GOOGLE_AUTHORIZATION_URL, params=params).prepare().url
    return {"redirect_uri": authorization_url}

@router.get("/google/callback")
async def google_callback(request: Request):
    code = request.query_params.get("code")
    if not code:
        return {"error": "Missing code parameter"}

    token_data = {
        "code": code,
        "client_id": Config.GOOGLE_CLIENT_ID,
        "client_secret": Config.GOOGLE_CLIENT_SECRET,
        "redirect_uri": GOOGLE_REDIRECT_URI,
        "grant_type": "authorization_code"
    }

    token_response = requests.post(GOOGLE_TOKEN_URL, data=token_data, timeout=10)
    token_response_data = token_response.json()

    if "error" in token_response_data:
        return {"error": token_response_data["error"]}

    access_token = token_response_data["access_token"]
    userinfo_response = requests.get(GOOGLE_USERINFO_URL, headers={"Authorization": f"Bearer {access_token}"}, timeout=10)
    userinfo = userinfo_response.json()

    return userinfo


# Test endpoints
@router.get('/protected', response_model=dict)
async def protected(token=Depends(auth_scheme)):
    return {"message": "protected endpoint"}

@router.get('/youtube', response_model=dict)
async def youtube(Authorize: AuthJWT = Depends()):
    print("aaa", requests.get('https://www.googleapis.com/youtube/v3/videoCategories'))
    return {"message": "youtube endpoint"}
