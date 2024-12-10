# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from authlib.integrations.starlette_client import OAuth
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from starlette.requests import Request
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from fastapi.responses import RedirectResponse

from app.service import login_user, register_user
from app.config import Config
from app.database import DAO

from app.common import secure_endpoint

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
async def login_google(request: Request):
    redirect_uri = request.url_for('google_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri, access_type="offline", prompt="consent")

@router.get("/google/callback", include_in_schema=False)
async def google_callback(request: Request, Authorize: AuthJWT = Depends()):
    try:
        # Get the Google token and user info
        google_token = await oauth.google.authorize_access_token(request)
        user_info = google_token.get("userinfo")
        user_email = user_info["email"]

        # Create a JWT for your app
        access_token = Authorize.create_access_token(subject=user_email)
        user = await DAO.find_user_by_email(user_email)
        user["external_tokens"]["GOOGLE"] = google_token
        await DAO.update_user(user_email, user)

        # Redirect back to the frontend with the token
        frontend_url = "http://localhost:8081"  # Your frontend URL
        return RedirectResponse(f"{frontend_url}/?token={access_token}")
    except Exception as e:
        print(e, flush=True)
        # Redirect to the frontend with an error message
        frontend_url = "http://localhost:8081"
        return RedirectResponse(f"{frontend_url}/?error=OAuthFailed")

@router.get('/me', response_model=dict)
@secure_endpoint
async def is_login(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    return {"detail": "Connected"}
