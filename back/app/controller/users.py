from fastapi import APIRouter
from app.database import DAO

router = APIRouter()

@router.get('/get/all')
async def get_all_users():
    users = await DAO.find_all_users()
    return {"users": [DAO.serialize_document(user) for user in users]}

@router.get('/get/email')
async def get_user_by_email(email: str):
    user = await DAO.find_user_by_email(email)
    if user:
        return DAO.serialize_document(user)
    return {"message": "User not found"}
