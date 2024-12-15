from fastapi import APIRouter, Request
from datetime import datetime

router = APIRouter()

@router.get('/about.json', response_model=dict)
def about_json(request: Request):
    return {
        "client": {
            "host": request.client.host,
        },
        "server": {
            "current_time": int(datetime.utcnow().timestamp()),
            "host": "127.0.0.1:5000",
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
