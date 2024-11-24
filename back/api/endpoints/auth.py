from fastapi import APIRouter, Depends, HTTPException, status
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from services import login_user, register_user

auth_router = APIRouter()

class UserCredentials(BaseModel):
    username: str
    password: str

@auth_router.post('/login', response_model=dict)
async def login_endpoint(credentials: UserCredentials, Authorize: AuthJWT = Depends()):
    access_token = await login_user(credentials.username, credentials.password, Authorize)
    if access_token:
        return {"token": access_token}
    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid username or password")

@auth_router.post('/register', response_model=dict)
async def register_endpoint(credentials: UserCredentials, Authorize: AuthJWT = Depends()):
    if await register_user(credentials.username, credentials.password):
        access_token = await login_user(credentials.username, credentials.password, Authorize)
        return {"token": access_token}
    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Username already exists")

@auth_router.get('/protected', response_model=dict)
async def protected_endpoint(Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()
    return {"message": "protected endpoint"}
