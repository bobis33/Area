from fastapi import APIRouter, Request
from datetime import datetime

from app.service import Service, get_actions_service, get_reactions_service

router = APIRouter()

@router.get('/about.json', response_model=dict)
async def about_json(request: Request):
    server_host = request.url.hostname
    server_port = request.url.port
    server_address = f"{server_host}:{server_port}" if server_port else server_host

    about = {
        "client": {
            "host": request.client.host,
        },
        "server": {
            "current_time": int(datetime.now().timestamp()),
            "host": server_address,
            "version": "0.0.0+1",
            "services": {}
        }
    }

    actions = await get_actions_service()
    reactions = await get_reactions_service()

    for service in Service:
        about["server"]["services"][service] = {"actions": [], "reactions": []}

        for action in actions:
            if action.service == service:
                about["server"]["services"][service]["actions"].append({"name": action.name, "description": action.description})

        for reaction in reactions:
            if reaction.service == service:
                about["server"]["services"][service]["reactions"].append({"name": reaction.name, "description": reaction.description})

    return about
