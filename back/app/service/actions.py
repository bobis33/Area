import time
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

from .areaComponents import IAction, Service
from app.config import Config



class MailRecvAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "Mail Received"
        self.description = "Triggers when a new mail is received by the logged in gmail user"
        self.service = Service.GMAIL

    def is_triggered(self, user) -> bool:
        try:
            google_infos = user['external_tokens']['GOOGLE']

            creds = Credentials(
                token=google_infos["access_token"],
                refresh_token=google_infos["refresh_token"],
                token_uri="https://oauth2.googleapis.com/token",
                client_id=Config.GOOGLE_CLIENT_ID,
                client_secret=Config.GOOGLE_CLIENT_SECRET,
                scopes=["https://www.googleapis.com/auth/gmail.readonly"]
            )
            service = build('gmail', 'v1', credentials=creds)

            now = int(time.time())
            ten_seconds_ago = now - 10

            query = f"after:{ten_seconds_ago}"

            # pylint: disable=E1101
            results = service.users().messages().list(userId='me', q=query).execute()
            messages = results.get('messages', [])

            return len(messages) > 0

        except HttpError as error:
            print(f"An error occurred: {error}", flush=True)
            return False
