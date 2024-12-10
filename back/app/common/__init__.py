from fastapi import Depends, HTTPException
from fastapi_jwt_auth import AuthJWT
from fastapi_jwt_auth.exceptions import AuthJWTException
from starlette.middleware.sessions import SessionMiddleware

from app.config import Config

from .security import secure_endpoint, auth_scheme, TokenManager

def init_app(app):
    app.add_middleware(SessionMiddleware, Config.MIDDLEWARE_SECRET_KEY)
