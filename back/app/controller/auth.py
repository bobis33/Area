# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi_jwt_auth import AuthJWT
from authlib.integrations.starlette_client import OAuth
from pydantic import BaseModel

from app.config import Config
from app.service import (
    login_user,
    register_user,
    is_linked_google_service,
    is_linked_discord_service,
    is_linked_spotify_service,
    is_linked_github_service,
    is_linked_gitlab_service,
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

oauth.register(
    name='github',
    client_id=Config.GITHUB_CLIENT_ID,
    client_secret=Config.GITHUB_CLIENT_SECRET,
    authorize_url='https://github.com/login/oauth/authorize',
    authorize_params=None,
    access_token_url='https://github.com/login/oauth/access_token',
    access_token_params=None,
    client_kwargs={'scope': 'user:email repo read:user public_repo'},
)

oauth.register(
    name='discord',
    client_id=Config.DISCORD_CLIENT_ID,
    client_secret=Config.DISCORD_CLIENT_SECRET,
    authorize_url='https://discord.com/api/oauth2/authorize',
    authorize_params=None,
    access_token_url='https://discord.com/api/oauth2/token',
    access_token_params=None,
    client_kwargs={'scope': 'identify email'},
)

oauth.register(
    name='spotify',
    client_id=Config.SPOTIFY_CLIENT_ID,
    client_secret=Config.SPOTIFY_CLIENT_SECRET,
    authorize_url='https://accounts.spotify.com/authorize',
    authorize_params=None,
    access_token_url='https://accounts.spotify.com/api/token',
    access_token_params=None,
    client_kwargs={'scope': 'user-read-email user-read-private user-read-playback-state user-modify-playback-state user-read-currently-playing user-library-read user-library-modify user-read-playback-position user-read-recently-played user-top-read playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private user-follow-read user-follow-modify user-read-email user-read-private'},
)

oauth.register(
    name='gitlab',
    client_id=Config.GITLAB_CLIENT_ID,
    client_secret=Config.GITLAB_CLIENT_SECRET,
    authorize_url='https://gitlab.com/oauth/authorize',
    authorize_params=None,
    access_token_url='https://gitlab.com/oauth/token',
    access_token_params=None,
    client_kwargs={'scope': 'read_user read_api read_repository read_registry write_repository write_registry'},
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

@router.get('/me', response_model=dict)
@secure_endpoint
async def is_login(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    return {"detail": "Connected"}

@router.get("/is/linked/google")
@secure_endpoint
async def is_linked_google(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    response = await is_linked_google_service(username)
    if response == True:
        return {"linked": True}
    else:
        return {"linked": False}

@router.get("/is/linked/discord")
@secure_endpoint
async def is_linked_discord(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    response = await is_linked_discord_service(username)
    if response == True:
        return {"linked": True}
    else:
        return {"linked": False}

@router.get("/is/linked/spotify")
@secure_endpoint
async def is_linked_spotify(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    response = await is_linked_spotify_service(username)
    if response == True:
        return {"linked": True}
    else:
        return {"linked": False}

@router.get("/is/linked/github")
@secure_endpoint
async def is_linked_github(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    response = await is_linked_github_service(username)
    if response == True:
        return {"linked": True}
    else:
        return {"linked": False}

@router.get("/is/linked/gitlab")
@secure_endpoint
async def is_linked_gitlab(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    username = TokenManager.get_token_subject(token)
    response = await is_linked_gitlab_service(username)
    if response == True:
        return {"linked": True}
    else:
        return {"linked": False}