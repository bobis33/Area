from fastapi import FastAPI
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from motor.motor_asyncio import AsyncIOMotorClient
from endpoints.auth import auth_router
from config import JWT_SECRET_KEY, MONGO_URI
import uvicorn

class Settings(BaseModel):
    authjwt_secret_key: str = JWT_SECRET_KEY

app = FastAPI()

@AuthJWT.load_config
def get_config():
    return Settings()

client = AsyncIOMotorClient(MONGO_URI)
db = client.get_default_database()

app.include_router(auth_router, prefix="/auth")

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=5000, log_level="debug")
