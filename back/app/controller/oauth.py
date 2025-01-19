
# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends
from fastapi.security import HTTPBearer
from fastapi.responses import RedirectResponse
from fastapi_jwt_auth import AuthJWT
from starlette.requests import Request


from app.config import Config
from app.service import (
    area_oauth_google_login,
    area_oauth_discord_login,
    area_oauth_spotify_login,
)

from .auth import oauth

router = APIRouter()
auth_scheme = HTTPBearer()

# ----------------------------------------------------------------------- DISCORD -------------------------------------------------------------
@router.get("/login/with/discord")
async def login_discord(request: Request):
    redirect_uri = request.url_for('discord_token_callback')
    return await oauth.discord.authorize_redirect(request, redirect_uri)

@router.get("/login/with/discord/callback", include_in_schema=False)
async def discord_token_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        discord_token = await oauth.discord.authorize_access_token(request)
        access_token = authorize.create_access_token(await area_oauth_discord_login(discord_token))

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?token={access_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={access_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")


# ----------------------------------------------------------------------- GOOGLE -------------------------------------------------------------
@router.get("/login/with/google")
async def login_google(request: Request):
    redirect_uri = request.url_for('google_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri, access_type="offline", prompt="consent")

@router.get("/login/with/google/callback", include_in_schema=False)
async def google_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        google_token = await oauth.google.authorize_access_token(request)
        access_token = authorize.create_access_token(await area_oauth_google_login(google_token))

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?token={access_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={access_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")


# ----------------------------------------------------------------------- SPOTIFY -------------------------------------------------------------
@router.get("/login/with/spotify")
async def login_spotify(request: Request):
    redirect_uri = request.url_for('spotify_token_callback')
    return await oauth.spotify.authorize_redirect(request, redirect_uri)

@router.get("/login/with/spotify/callback", include_in_schema=False)
async def spotify_token_callback(request: Request, authorize: AuthJWT = Depends()):
    try:
        client_type = "mobile" if "mobile" in request.headers.get("User-Agent", "").lower() else "web"
        spotify_token = await oauth.spotify.authorize_access_token(request)
        access_token = authorize.create_access_token(await area_oauth_spotify_login(spotify_token))

        if client_type == "mobile":
            return RedirectResponse(f"{Config.MOBILE_URL}?token={access_token}")

        return RedirectResponse(f"{Config.FRONTEND_URL}/?token={access_token}")
    except Exception as e:
        print("Exception occured:", e, flush=True)
        return RedirectResponse(f"{Config.FRONTEND_URL}/?error=OAuthFailed")
