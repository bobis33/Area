from fastapi import HTTPException
from fastapi import APIRouter, Depends
from fastapi.security import HTTPAuthorizationCredentials
from app.common import auth_scheme, TokenManager
from passlib.context import CryptContext

from app.database import DAO
from app.common import secure_endpoint

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
router = APIRouter()

@router.get('/get/all', response_model=dict)
@secure_endpoint
async def get_all_users(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    users = await DAO.find_all_users()
    for i, user in enumerate(users):
        user = DAO.serialize_document(user)
        users[i] = {"_id": user["_id"], "subscribed_areas": user["subscribed_areas"],
                    "created_at": user["created_at"], "updated_at": user["updated_at"]}

    return {"users": users}

@router.get('/get/self', response_model=dict)
@secure_endpoint
async def get_self(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    self_user = await DAO.find_user_by_username(TokenManager.get_token_subject(token))
    self_user["external_tokens"] = "HIDDEN"

    return {"user": DAO.serialize_document(self_user)}


@router.patch('/update/username', response_model=dict)
@secure_endpoint
async def update_username(username: str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    try:
        user = await DAO.find_user_by_username(TokenManager.get_token_subject(token))
        user["username"] = username
        await DAO.update_user(user["username"], user)
        return {"message": "username updated successfully"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.patch('/update/password', response_model=dict)
@secure_endpoint
async def update_password(password: str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    try:
        user = await DAO.find_user_by_username(TokenManager.get_token_subject(token))
        user["password"] = pwd_context.hash(password)
        await DAO.update_user(user["password"], user)
        return {"message": "password updated successfully"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
