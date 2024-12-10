from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi_jwt_auth.exceptions import AuthJWTException
from fastapi_jwt_auth import AuthJWT
from fastapi import APIRouter, Depends
from fastapi.security import HTTPAuthorizationCredentials
from app.common import secure_endpoint, auth_scheme, TokenManager


from app.database import DAO
from app.common import secure_endpoint

from app.config import Config

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
    self_user = await DAO.find_user_by_email(TokenManager.get_token_subject(token))
    self_user["external_tokens"] = "HIDDEN"

    return {"user": DAO.serialize_document(self_user)}
