from app.config import Config

from starlette.middleware.sessions import SessionMiddleware

def init_app(app):
    app.add_middleware(SessionMiddleware, Config.MIDDLEWARE_SECRET_KEY)
