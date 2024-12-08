# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from authlib.integrations.starlette_client import OAuth
from fastapi.security import HTTPBearer
from starlette.requests import Request
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
import requests

from app.service import login_user, register_user
from app.config import Config


router = APIRouter()
auth_scheme = HTTPBearer()

oauth = OAuth()
oauth.register(
    name = 'google',
    client_id = Config.GOOGLE_CLIENT_ID,
    client_secret = Config.GOOGLE_CLIENT_SECRET,
    server_metadata_url = Config.GOOGLE_SERVER_METADATA_URL,
    client_kwargs = {'scope': 'openid email profile'}
)

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
@router.get("/login/google")
async def login_google(request: Request, token=Depends(auth_scheme)):
    redirect_uri = request.url_for('google_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri)

@router.get("/google/callback")
async def google_callback(request: Request, Authorize: AuthJWT = Depends()):
    google_token = await oauth.google.authorize_access_token(request)
    user_infos = google_token['userinfo']
    return user_infos


# Test endpoints
@router.get('/protected', response_model=dict)
async def protected(token=Depends(auth_scheme)):
    return {"message": "protected endpoint"}

@router.get('/youtube', response_model=dict)
async def youtube(Authorize: AuthJWT = Depends()):
    print("aaa", requests.get('https://www.googleapis.com/youtube/v3/videoCategories'))
    return {"message": "youtube endpoint"}
