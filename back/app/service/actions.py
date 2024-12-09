import time
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

from app.config import Config

async def test_action(user):
    return True

async def mail_received(user):
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
        # Initialize the Gmail API service
        service = build('gmail', 'v1', credentials=creds)

        # Get the current time and calculate the UNIX timestamp for 10 seconds ago
        now = int(time.time())
        ten_seconds_ago = now - 10

        # Use the `after` query to filter emails received after `ten_seconds_ago`
        query = f"after:{ten_seconds_ago}"

        # Fetch messages using Gmail API
        # pylint: disable=E1101
        results = service.users().messages().list(userId='me', q=query).execute()
        messages = results.get('messages', [])

        # Return True if there are messages, False otherwise
        return len(messages) > 0

    except HttpError as error:
        print(f"An error occurred: {error}", flush=True)
        return False
