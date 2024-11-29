from fastapi import APIRouter, Depends, HTTPException, status
from authlib.integrations.starlette_client import OAuth
from starlette.requests import Request
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel

from app.service import login_user, register_user
from app.config import Config


router = APIRouter()

oauth = OAuth()
oauth.register(
    name = 'google',
    client_id = Config.GOOGLE_CLIENT_ID,
    client_secret = Config.GOOGLE_CLIENT_SECRET,
    server_metadata_url = Config.GOOGLE_SERVER_METADATA_URL,
    client_kwargs = {'scope': 'openid email profile'}
)

class UserCredentials(BaseModel):
    username: str
    password: str

@router.post('/login', response_model=dict)
async def login(credentials: UserCredentials, authorize: AuthJWT = Depends()):
    access_token = await login_user(credentials.username, credentials.password, authorize)
    if access_token:
        return {"token": access_token}
    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                        detail="Invalid username or password")

@router.post('/register', response_model=dict)
async def register(credentials: UserCredentials, authorize: AuthJWT = Depends()):
    if await register_user(credentials.username, credentials.password):
        access_token = await login_user(credentials.username, credentials.password, authorize)
        return {"token": access_token}
    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                        detail="Username already exists")

@router.get('/protected', response_model=dict)
async def protected(Authorize: AuthJWT = Depends()):
    try:
        Authorize.jwt_required()
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Unauthorized") from e

    return {"message": "protected endpoint"}

@router.get("/login/google")
async def login_google(request: Request):
    redirect_uri = request.url_for('google_callback')
    return await oauth.google.authorize_redirect(request, redirect_uri)

@router.get("/google/callback")
async def google_callback(request: Request):
    token = await oauth.google.authorize_access_token(request)
    user = token['userinfo']
    return dict(user)
