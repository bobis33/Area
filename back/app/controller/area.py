from fastapi import APIRouter, Depends
from fastapi.security import HTTPAuthorizationCredentials
from inspect import getmembers, isfunction

from app.database import DAO
from app.service import actions, reactions
from app.common import secure_endpoint, auth_scheme, TokenManager


router = APIRouter()

@router.get('/get/actions', response_model=dict)
@secure_endpoint
async def get_actions(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    result = []

    functions = getmembers(actions, isfunction)
    for function in functions:
        if function[0] == "build":
            continue

        if function[0][0] == "_":
            continue

        result.append({
            "name": function[0],
            "description": function[1].__doc__  # Access the function object (function[1]) and get its __doc__
        })

    return {"actions": result}

@router.get('/get/reactions', response_model=dict)
@secure_endpoint
async def get_reactions(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    result = []

    functions = getmembers(reactions, isfunction)
    for function in functions:
        if function[0] == "build":
            continue

        if function[0][0] == "_":
            continue

        result.append({
            "name": function[0],
            "description": function[1].__doc__  # Access the function object (function[1]) and get its __doc__
        })

    return {"actions": result}

# pylint: disable=unused-argument
@router.get('/get/subscribed', response_model=dict)
@secure_endpoint
async def get_subscribed_areas(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    subject = TokenManager.get_token_subject(token)
    user = await DAO.find_user_by_email(subject)

    result = []
    for area_id in list(user["subscribed_areas"]):
        result.append(DAO.serialize_document(await DAO.find_area_by_id(area_id)))

    return {"subscribed_areas": result}

@router.get('/get/all', response_model=dict)
@secure_endpoint
async def get_all_areas(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    areas = await DAO.find_all_areas()
    return {"areas": areas}

@router.post('/create', response_model=dict)
@secure_endpoint
async def create_area(action:str, reaction:str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    await DAO.insert_area({"action": action, "reaction": reaction, "subscribed_users": []})
    return {"message": "ok"}

@router.post('/subscribe')
@secure_endpoint
async def subscribe_to_area(area_id: str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    user_email = TokenManager.get_token_subject(token)

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
@secure_endpoint
async def unsubscribe_to_area(area_id: str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    user_email = TokenManager.get_token_subject(token)

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
