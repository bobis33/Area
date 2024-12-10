from fastapi import APIRouter

router = APIRouter()

@router.get('/about/json', response_model=dict)
def about_json():
    return {
        "client": "127.0.0.1:8081",
        "server": "127.0.0.1:5000",
        "services": [
            {
                "name": "google",
                "actions": [
                    {"mail_received": "trigger when a mail is received"}
                ],
                "reactions": [
                    {"send_email_to_antoine": "send an email to this address: cretace@icloud.com"}
                ]
            }
        ]
    }
