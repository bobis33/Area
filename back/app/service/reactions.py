import aiohttp
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

    async def get_params(self):
        return {"To": "None", "Subject": "None", "Content": "None"}

    async def react(self, user, params):
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

        message.set_content(params["Content"])
        message["To"] = params["To"]
        message["From"] = user["email"]
        message["Subject"] = params["Subject"]

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

class RepoCreationReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Create repo"
        self.description = "Create a repo on the logged in user's github account"
        self.service = Service.GMAIL

    async def get_params(self):
        return {"name": "area_reaction"}

    async def react(self, user, params):
        """Create a private GitHub repository named 'ok'"""
        try:
            github_infos = user['external_tokens']['GITHUB']
            access_token = github_infos["access_token"]

            async with aiohttp.ClientSession() as session:
                headers = {
                    'Authorization': f'Bearer {access_token}',
                    'Accept': 'application/vnd.github.v3+json'
                }
                data = {
                    "name": params["name"],
                    "private": True
                }
                async with session.post('https://api.github.com/user/repos', headers=headers, json=data) as response:
                    if response.status != 201:
                        raise Exception(f"GitHub API request failed with status {response.status}")
                    repo_info = await response.json()
                    print(f"Repository created: {repo_info['html_url']}", flush=True)
                    return True

        except Exception as error:
            print(f"An error occurred: {error}", flush=True)
            return False
