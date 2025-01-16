from starlette.middleware.sessions import SessionMiddleware

from app.config import Config

from .security import secure_endpoint, auth_scheme, TokenManager
from.name_generator import NameGenerator

def init_app(app):
    app.add_middleware(SessionMiddleware, Config.MIDDLEWARE_SECRET_KEY)
