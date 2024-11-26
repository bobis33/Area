# pylint: disable=no-name-in-module
# pylint: disable=no-self-argument
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi_jwt_auth import AuthJWT
from pydantic import BaseModel
from app.service import login_user, register_user

router = APIRouter()

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
