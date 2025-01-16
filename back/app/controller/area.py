from inspect import getmembers

from fastapi import APIRouter, Depends
from fastapi.security import HTTPAuthorizationCredentials
from typing_extensions import TypedDict
from pydantic import Json


from app.database import DAO
from app.common import secure_endpoint, auth_scheme, TokenManager
from app.service import (
    get_actions_service,
    get_reactions_service
)

router = APIRouter()

@router.get('/get/actions')
@secure_endpoint
async def get_actions(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    result = []
    actions = await get_actions_service()
    for action in actions:
        result.append({
            "name": action.name,
            "description": action.description,
            "service": action.service.value,
            "params": await action.get_params()
        })

    return {"actions": result}

@router.get('/get/reactions')
@secure_endpoint
async def get_reactions(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    result = []

    reactions = await get_reactions_service()
    for reaction in reactions:
        result.append({
            "name": reaction.name,
            "description": reaction.description,
            "service": reaction.service.value,
            "params": await reaction.get_params()
        })

    return {"reactions": result}

# pylint: disable=unused-argument
@router.get('/get/subscribed', response_model=dict)
@secure_endpoint
async def get_subscribed_areas(token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    subject = TokenManager.get_token_subject(token)
    user = await DAO.find_user_by_username(subject)

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
async def create_area(action:str, reaction:str, action_params:Json, reaction_params:Json, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    await DAO.insert_area({"action": action, "reaction": reaction,
                           "action_params": action_params, "reaction_params": reaction_params,
                           "subscribed_users": []})

    return {"message": "ok"}

@router.post('/subscribe')
@secure_endpoint
async def subscribe_to_area(area_id: str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    user_username = TokenManager.get_token_subject(token)

    user = await DAO.find_user_by_username(user_username)
    area = await DAO.find_area_by_id(area_id)

    if area is None:
        return {"message": "Area not found"}

    if area_id in user["subscribed_areas"]:
        return {"message": "Already subscribed"}

    user["subscribed_areas"].append(area_id)
    await DAO.update_user(user_username, user)

    area["subscribed_users"].append(user_username)
    await DAO.update_area(area_id, area)

    return {"message": "Subscribed"}

@router.post('/unsubscribe')
@secure_endpoint
async def unsubscribe_to_area(area_id: str, token: HTTPAuthorizationCredentials = Depends(auth_scheme)):
    user_username = TokenManager.get_token_subject(token)

    user = await DAO.find_user_by_username(user_username)
    area = await DAO.find_area_by_id(area_id)

    if area is None:
        return {"message": "Area not found"}

    if area_id not in user["subscribed_areas"]:
        return {"message": "Not subscribed"}

    user["subscribed_areas"].remove(area_id)
    await DAO.update_user(user_username, user)

    area["subscribed_users"].remove(user_username)
    await DAO.update_area(area_id, area)

    return {"message": "Unsubscribed"}
