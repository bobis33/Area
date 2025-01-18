import aiohttp
import base64
import requests
from email.message import EmailMessage
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from discord import Client, Intents
from discord.ext import commands
from app.fast import app
import asyncio

from app.config import Config
from .areaComponents import IReaction, Service

from app.database import DAO, get_database


# ------------------------------------- Discord Bot -------------------------------------
bot = commands.Bot(command_prefix="!", intents=Intents.all())

@app.on_event("startup")
async def start_bot():
    async def run_bot():
        await bot.login(Config.DISCORD_BOT_TOKEN)
        await bot.connect()

    loop = asyncio.get_event_loop()
    loop.create_task(run_bot())


# ------------------------------------- Reactions -------------------------------------
class SendMailReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Send Mail"
        self.description = "Send an email from the logged in user the given user"
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

class RepoCreationReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Create repo"
        self.description = "Create a repo on the logged in user's github account"
        self.service = Service.GITHUB

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

class PlaySongReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Play Song"
        self.description = "Play a specific song on the user's Spotify account. (WARNING: will fail if spotify is not active on the specified device)"
        self.service = Service.SPOTIFY

    async def get_params(self):
        return {"Track URI": "None", "Device ID": "None"}

    async def react(self, user, params):
        spotify_infos = await DAO.find(get_database().spotify_users, "_id", user['linked_to']['spotify'])

        access_token = spotify_infos["token"]["access_token"]
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }

        body = {"uris": [params["Track URI"]]}
        if params["Device ID"] != "None":
            body["device_id"] = params["Device ID"]

        response = requests.put(
            "https://api.spotify.com/v1/me/player/play",
            headers=headers,
            json=body
        )

        if response.status_code == 204:
            print("Track started successfully.", flush=True)
        else:
            print(f"Failed to play track: {response.status_code} {response.text}", flush=True)

class AddToPlaylistReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Add Song to Playlist"
        self.description = "Add a specific song to a user's Spotify playlist."
        self.service = Service.SPOTIFY

    async def get_params(self):
        return {"Track URI": "None", "Playlist ID": "None"}

    async def react(self, user, params):
        spotify_infos = await DAO.find(get_database().spotify_users, "_id", user['linked_to']['spotify'])

        access_token = spotify_infos["token"]["access_token"]
        headers = {
            "Authorization": f"Bearer {access_token}",
            "Content-Type": "application/json"
        }

        body = {"uris": [params["Track URI"]]}

        response = requests.post(
            f"https://api.spotify.com/v1/playlists/{params['Playlist ID']}/tracks",
            headers=headers,
            json=body
        )

        if response.status_code == 201:
            print("Track added to playlist successfully.", flush=True)
        else:
            print(f"Failed to add track: {response.status_code} {response.text}", flush=True)

class SendDiscordMessageReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Send discord message"
        self.description = "Send a message to a discord channel"
        self.service = Service.DISCORD

    async def get_params(self):
        return {"Channel ID": "None", "Message": "None"}

    async def react(self, user, params):
        channel = bot.get_channel(int(params["Channel ID"]))
        await channel.send(params["Message"])

class SendDiscordDMReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Send discord DM"
        self.description = "Send a direct message to a discord user"
        self.service = Service.DISCORD

    async def get_params(self):
        return {"User ID": "None", "Message": "None"}

    async def react(self, user, params):
        user = bot.get_user(int(params["User ID"]))
        await user.send(params["Message"])

class KickDiscordUserReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Kick discord user"
        self.description = "Kick a user from a discord server"
        self.service = Service.DISCORD

    async def get_params(self):
        return {"User ID": "None", "Guild ID": "None"}

    async def react(self, user, params):
        guild = bot.get_guild(int(params["Guild ID"]))
        member = guild.get_member(int(params["User ID"]))
        await member.kick()

class BanDiscordUserReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Ban discord user"
        self.description = "Ban a user from a discord server"
        self.service = Service.DISCORD

    async def get_params(self):
        return {"User ID": "None", "Guild ID": "None"}

    async def react(self, user, params):
        guild = bot.get_guild(int(params["Guild ID"]))
        member = guild.get_member(int(params["User ID"]))
        await member.ban()

class AddRoleToDiscordUserReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Add role to discord user"
        self.description = "Add a role to a user in a discord server"
        self.service = Service.DISCORD

    async def get_params(self):
        return {"User ID": "None", "Guild ID": "None", "Role ID": "None"}

    async def react(self, user, params):
        guild = bot.get_guild(int(params["Guild ID"]))
        member = guild.get_member(int(params["User ID"]))
        role = guild.get_role(int(params["Role ID"]))
        await member.add_roles(role)

class RemoveRoleFromDiscordUserReaction(IReaction):
    def __init__(self):
        super().__init__()
        self.name = "Remove role from discord user"
        self.description = "Remove a role from a user in a discord server"
        self.service = Service.DISCORD

    async def get_params(self):
        return {"User ID": "None", "Guild ID": "None", "Role ID": "None"}

    async def react(self, user, params):
        guild = bot.get_guild(int(params["Guild ID"]))
        member = guild.get_member(int(params["User ID"]))
        role = guild.get_role(int(params["Role ID"]))
        print(role, member, flush=True)
        await member.remove_roles(role)
