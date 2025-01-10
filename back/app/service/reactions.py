import base64
import random
from email.message import EmailMessage

from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

from app.config import Config

from .areaComponents import IReaction, Service

class SendMailReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Send Mail To Antoine"
        self.description = "Send an email from the logged in user to antoine's dm"
        self.service = Service.GMAIL

    def react(self, user):
        google_infos = user['external_tokens']['GOOGLE']

        creds = Credentials(
            token=google_infos["access_token"],
            refresh_token=google_infos["refresh_token"],
            token_uri="https://oauth2.googleapis.com/token",
            client_id=Config.GOOGLE_CLIENT_ID,
            client_secret=Config.GOOGLE_CLIENT_SECRET,
            scopes=["https://www.googleapis.com/auth/gmail.send"]
        )

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
