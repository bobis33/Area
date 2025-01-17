# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import RedirectResponse
from starlette.requests import Request
from pydantic import BaseModel


from app.config import Config
from app.service import (
    link_to_google,
    link_to_discord,
    link_to_spotify,
    link_to_github,
    oauth_google_login,
    oauth_discord_login,
    oauth_spotify_login,
    oauth_github_login,
)
from app.common import secure_endpoint, TokenManager

from .auth import oauth


router = APIRouter()
auth_scheme = HTTPBearer()

class Credentials(BaseModel):
    username: str
    password: str

# ----------------------------------------------------------------------- GITHUB -------------------------------------------------------------
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
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        github_token = await oauth.github.authorize_access_token(request)
        await oauth_github_login(github_token)

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?spotify_token={github_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?spotify_token={github_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

# ----------------------------------------------------------------------- DISCORD -------------------------------------------------------------
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
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        discord_token = await oauth.discord.authorize_access_token(request)
        await oauth_discord_login(discord_token)

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?spotify_token={discord_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?spotify_token={discord_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

# ----------------------------------------------------------------------- GOOGLE -------------------------------------------------------------
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
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        google_token = await oauth.google.authorize_access_token(request)
        await oauth_google_login(google_token)

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?google_token={google_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?google_token={google_token}")

    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")

# ----------------------------------------------------------------------- SPOTIFY -------------------------------------------------------------
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
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        spotify_token = await oauth.spotify.authorize_access_token(request)
        await oauth_spotify_login(spotify_token)

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?spotify_token={spotify_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?spotify_token={spotify_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")
