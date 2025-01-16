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
    link_to_discord,
    link_to_spotify,
    link_to_github,
    oauth_google_login,
    area_oauth_google_login,
    oauth_discord_login,
    area_oauth_discord_login,
    oauth_spotify_login,
    area_oauth_spotify_login,
    oauth_github_login,
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


@router.post('/link/github')
@secure_endpoint
async def link_github(github_token, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    try:
        await link_to_github(TokenManager.get_token_subject(token), github_token)
        return {"message": "GitHub account linked successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=e.args) from e

@router.get("/login/to/github")
async def get_github_login(request: Request):
    redirect_uri = request.url_for('github_callback')
    return await oauth.github.authorize_redirect(request, redirect_uri)

@router.get("/login/to/github/callback", include_in_schema=False)
async def github_callback(request: Request):
    try:
        github_token = await oauth.github.authorize_access_token(request)
        await oauth_github_login(github_token)

        return RedirectResponse(f"{Config.FRONTEND_URL}/?github_token={github_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")


@router.post('/link/discord')
@secure_endpoint
async def link_discord(discord_token, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    try:
        await link_to_discord(TokenManager.get_token_subject(token), discord_token)
        return {"message": "Discord account linked successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=e.args) from e

@router.get("/login/to/discord")
async def get_discord_login(request: Request):
    redirect_uri = request.url_for('discord_callback')
    return await oauth.discord.authorize_redirect(request, redirect_uri)

@router.get("/login/to/discord/callback", include_in_schema=False)
async def discord_callback(request: Request):
    try:
        discord_token = await oauth.discord.authorize_access_token(request)
        await oauth_discord_login(discord_token)

        return RedirectResponse(f"{Config.FRONTEND_URL}/?discord_token={discord_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

@router.get("/login/with/discord")
async def login_discord(request: Request):
    redirect_uri = request.url_for('discord_token_callback')
    print(redirect_uri, flush=True)
    return await oauth.discord.authorize_redirect(request, redirect_uri)

@router.get("/login/with/discord/callback", include_in_schema=False)
async def discord_token_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        discord_token = await oauth.discord.authorize_access_token(request)
        access_token = authorize.create_access_token(await area_oauth_discord_login(discord_token))

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={discord_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")


@router.post('/link/google')
@secure_endpoint
async def link_google(google_token, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    try:
        await link_to_google(TokenManager.get_token_subject(token), google_token)
        return {"message": "Google account linked successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=e.args) from e

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
        access_token = authorize.create_access_token(await area_oauth_google_login(google_token))

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={access_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

@router.get('/me', response_model=dict)
@secure_endpoint
async def is_login(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    return {"detail": "Connected"}

@router.post('/link/spotify')
@secure_endpoint
async def link_spotify(spotify_token, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    try:
        await link_to_spotify(TokenManager.get_token_subject(token), spotify_token)
        return {"message": "Spotify account linked successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=e.args) from e

@router.get("/login/to/spotify")
async def get_spotify_login(request: Request):
    redirect_uri = request.url_for('spotify_callback')
    return await oauth.spotify.authorize_redirect(request, redirect_uri)

@router.get("/login/to/spotify/callback", include_in_schema=False)
async def spotify_callback(request: Request):
    try:
        spotify_token = await oauth.spotify.authorize_access_token(request)
        await oauth_spotify_login(spotify_token)

        return RedirectResponse(f"{Config.FRONTEND_URL}/?spotify_token={spotify_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

@router.get("/login/with/spotify")
async def login_spotify(request: Request):
    redirect_uri = request.url_for('spotify_token_callback')
    print(redirect_uri, flush=True)
    return await oauth.spotify.authorize_redirect(request, redirect_uri)

@router.get("/login/with/spotify/callback", include_in_schema=False)
async def spotify_token_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        spotify_token = await oauth.spotify.authorize_access_token(request)
        access_token = authorize.create_access_token(await area_oauth_spotify_login(spotify_token))

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={spotify_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")