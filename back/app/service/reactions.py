import base64
from app.config import Config
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from email.message import EmailMessage

import random

async def test_reaction(user):
    print("Reaction triggered", flush=True)

async def send_email_to_antoine(user):
    google_infos = user['external_tokens']['GOOGLE']

    creds = Credentials(
        token=google_infos["access_token"],
        refresh_token=google_infos["refresh_token"],
        token_uri="https://oauth2.googleapis.com/token",
        client_id=Config.GOOGLE_CLIENT_ID,
        client_secret=Config.GOOGLE_CLIENT_SECRET,  # Replace with your actual client secret
        scopes=["https://www.googleapis.com/auth/gmail.send"]
    )

    # Build Gmail service
    service = build("gmail", "v1", credentials=creds)

    message = EmailMessage()

    message.set_content("passe TS " + str(random.randint(0, 100000000)))
    message["To"] = "cretace@icloud.com"
    message["From"] = user["email"]
    message["Subject"] = "J'ai remarque que tu avais beaucoup de paladium sur toi"

    encoded_message = base64.urlsafe_b64encode(message.as_bytes()).decode()
    create_message = {"raw": encoded_message}

    # pylint: disable=E1101
    send_message = (
        service.users()
        .messages()
        .send(userId="me", body=create_message)
        .execute()
    )

    print(f'Message Id: {send_message["id"]}', flush=True)
