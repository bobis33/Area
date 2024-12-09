from fastapi import APIRouter
from app.database import DAO

router = APIRouter()

@router.get('/get/triggers', response_model=dict)
async def get_triggers_list(user_email: str):
    return {"triggers": "None"}

@router.get('/get/subscribed', response_model=dict)
async def get_subscribed_areas(user_email: str):
    user = await DAO.find_user_by_email(user_email)
    result = []
    for area_id in list(user["subscribed_areas"]):
        result.append(DAO.serialize_document(await DAO.find_area_by_id(area_id)))

    return {"subscribed_areas": result}

@router.get('/get/all', response_model=dict)
async def get_all_areas():
    areas = await DAO.find_all_areas()
    return {"areas": areas}

@router.post('/create', response_model=dict)
async def create_area(action:str, reaction:str):
    await DAO.insert_area({"action": action, "reaction": reaction, "subscribed_users": []})
    return {"message": "ok"}

@router.post('/subscribe')
async def subscribe_user(user_email: str, area_id: str):
    user = await DAO.find_user_by_email(user_email)
    area = await DAO.find_area_by_id(area_id)

    if area is None:
        return {"message": "Area not found"}

    if area_id in user["subscribed_areas"]:
        return {"message": "Already subscribed"}

    user["subscribed_areas"].append(area_id)
    await DAO.update_user(user_email, user)

    area["subscribed_users"].append(user_email)
    await DAO.update_area(area_id, area)

    return {"message": "Subscribed"}

@router.post('/unsubscribe')
async def unsubscribe_user(user_email: str, area_id: str):
    user = await DAO.find_user_by_email(user_email)
    area = await DAO.find_area_by_id(area_id)

    if area is None:
        return {"message": "Area not found"}

    if area_id not in user["subscribed_areas"]:
        return {"message": "Not subscribed"}

    user["subscribed_areas"].remove(area_id)
    await DAO.update_user(user_email, user)

    area["subscribed_users"].remove(user_email)
    await DAO.update_area(area_id, area)

    return {"message": "Unsubscribed"}
