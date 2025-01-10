# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import RedirectResponse
from fastapi_jwt_auth import AuthJWT
from authlib.integrations.starlette_client import OAuth
from starlette.requests import Request
from pydantic import BaseModel

from app.config import Config
from app.service import (
    login_user,
    register_user,
    link_to_google,
    is_linked_google_service,
    oauth_google_login,
    area_oauth_google_login,
)

from app.common import secure_endpoint, TokenManager


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
    try:
        await link_to_google(TokenManager.get_token_subject(token), google_token)
        return {"message": "Google account linked successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=e.args) from e

@router.get("/is/linked/google")
@secure_endpoint
async def is_linked_google(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    response = await is_linked_google_service(username)
    if response == True:
        return {"linked": True}
    else:
        return {"linked": False}

@router.get("/login/to/google")
async def get_google_token(request: Request):
    redirect_uri = request.url_for('google_token_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri, access_type="offline", prompt="consent")

@router.get("/login/to/google/callback", include_in_schema=False)
async def google_token_callback(request: Request):
    try:
        google_token = await oauth.google.authorize_access_token(request)
        await oauth_google_login(google_token)

        return RedirectResponse(f"{Config.FRONTEND_URL}/?google_token={google_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

@router.get("/login/with/google")
async def login_google(request: Request):
    redirect_uri = request.url_for('google_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri, access_type="offline", prompt="consent")

@router.get("/login/with/google/callback", include_in_schema=False)
async def google_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        google_token = await oauth.google.authorize_access_token(request)
        access_token = authorize.create_access_token(area_oauth_google_login(google_token))

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={access_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

@router.get('/me', response_model=dict)
@secure_endpoint
async def is_login(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    return {"detail": "Connected"}
