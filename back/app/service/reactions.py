import base64
from app.config import Config
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from email.message import EmailMessage

async def test_reaction(user):
    print("Reaction triggered", flush=True)

async def send_email_to_antoine(user):
    google_infos = user['external_tokens']['GOOGLE']

    creds = Credentials(
        token=google_infos["access_token"],
        token_uri="https://oauth2.googleapis.com/token",
        client_id=Config.GOOGLE_CLIENT_ID,
        client_secret=Config.GOOGLE_CLIENT_SECRET,  # Replace with your actual client secret
        scopes=["https://www.googleapis.com/auth/gmail.send"]
    )

    # Build Gmail service
    service = build("gmail", "v1", credentials=creds)

    message = EmailMessage()

    message["To"] = "cretace@icloud.com"
    message["From"] = user["userinfo"]["email"]

    encoded_message = base64.urlsafe_b64encode(message.as_bytes()).decode()
    create_message = {"message": {"raw": encoded_message}}

    # pylint: disable=E1101
    draft = (
        service.users()
        .drafts()
        .create(userId="me", body=create_message)
        .execute()
    )

    print(f'Draft id: {draft["id"]}\nDraft message: {draft["message"]}', flush=True)