from fastapi import APIRouter, Request
from datetime import datetime

router = APIRouter()

@router.get('/about.json', response_model=dict)
def about_json(request: Request):
    server_host = request.url.hostname
    server_port = request.url.port
    server_address = f"{server_host}:{server_port}" if server_port else server_host
    return {
        "client": {
            "host": request.client.host,
        },
        "server": {
            "current_time": int(datetime.utcnow().timestamp()),
            "host": server_address,
            "version": "0.0.0+1",
            "services": [{
                "name": "google",
                "actions": [{
                    "name": "mail_received",
                    "description": "trigger when a mail is received",
                }],
                "reactions": [{
                    "name": "send_email_to_antoine",
                    "description": "send an email to this address: cretace@icloud.com",
                }]
            },
            {
                "name": "",
                "actions": [{
                    "name": "",
                    "description": "",
                }],
                "reactions": [{
                    "name": "",
                    "description": "",
                }]
            }]
        }
    }
