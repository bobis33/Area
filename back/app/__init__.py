# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
import uvicorn

from fastapi import FastAPI
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel

from .config import Config
from .common import init_app
from .controller import register_router

class Settings(BaseModel):
    authjwt_secret_key: str = Config.JWT_SECRET_KEY

@AuthJWT.load_config
def get_config():
    return Settings()

app = FastAPI()

def create_app(config_class=Config):
    init_app(app)

    register_router(app)

    return app

create_app()
