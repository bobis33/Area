import time
import aiohttp
import requests
from datetime import datetime, timezone, timedelta
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

from .areaComponents import IAction, Service
from app.config import Config
from app.database import DAO, get_database

class MailRecvAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "Mail Received"
        self.description = "Triggers when a new mail is received by the logged in gmail user"
        self.service = Service.GMAIL

    async def is_triggered(self, user, params) -> bool:
        try:
            google_infos = await DAO.find(get_database().google_users, "_id", user['linked_to']['google'])

            creds = Credentials(
                token=google_infos["token"]["access_token"],
                refresh_token=google_infos["token"]["refresh_token"],
                token_uri="https://oauth2.googleapis.com/token",
                client_id=Config.GOOGLE_CLIENT_ID,
                client_secret=Config.GOOGLE_CLIENT_SECRET,
                scopes=["https://www.googleapis.com/auth/gmail.readonly"]
            )
            service = build('gmail', 'v1', credentials=creds)

            now = int(time.time())
            ten_seconds_ago = now - Config.AREA_CHECK_INTERVAL

            query = f"after:{ten_seconds_ago}"

            # pylint: disable=E1101
            results = service.users().messages().list(userId='me', q=query).execute()
            messages = results.get('messages', [])

            return len(messages) > 0

        except HttpError as error:
            print(f"An error occurred: {error}", flush=True)
            return False

class GithubRepoCreatedAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "Github repo created"
        self.description = "Triggered when a repo is created"
        self.service = Service.GITHUB

    async def is_triggered(self, user, params) -> bool:
        """'github_repo_created' An action function that triggers when a GitHub repository is created
        """
        try:
            github_infos = user['linked_to']['GITHUB']
            access_token = github_infos["access_token"]
            username = user['github_username']

            async with aiohttp.ClientSession() as session:
                headers = {'Authorization': f'Bearer {access_token}'}
                async with session.get(f'https://api.github.com/search/repositories?q=user:{username}', headers=headers) as response:
                    if response.status != 200:
                        raise Exception(f"GitHub API request failed with status {response.status}")
                    result = await response.json()
                    repos = result.get('items', [])

            now = datetime.now(timezone.utc)

            for repo in repos:
                repo_creation_date = datetime.strptime(repo['created_at'], "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
                diff_seconds = (now - repo_creation_date).total_seconds()
                if diff_seconds < Config.AREA_CHECK_INTERVAL:
                    return True

            return False

        except Exception as error:
            print(f"An error occurred: {error}", flush=True)
            return False

class NewIssueAssignedAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "New Issue Assigned"
        self.description = "Triggers when a new issue is assigned to the user"
        self.service = Service.GITHUB

    async def is_triggered(self, user, params) -> bool:
        try:
            github_infos = user['linked_to']['GITHUB']
            access_token = github_infos["access_token"]
            username = user['github_username']

            async with aiohttp.ClientSession() as session:
                headers = {'Authorization': f'Bearer {access_token}'}
                async with session.get(f'https://api.github.com/issues?filter=assigned&state=open', headers=headers) as response:
                    if response.status != 200:
                        raise Exception(f"GitHub API request failed with status {response.status}")
                    issues = await response.json()

            now = datetime.now(timezone.utc)

            for issue in issues:
                if issue['assignee'] and issue['assignee']['login'] == username:
                    issue_creation_date = datetime.strptime(issue['created_at'], "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
                    diff_seconds = (now - issue_creation_date).total_seconds()
                    if diff_seconds < Config.AREA_CHECK_INTERVAL:
                        return True

            return False

        except Exception as error:
            print(f"An error occurred: {error}", flush=True)
            return False

class RepoStarCountUpdatedAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "Repo Star Count Updated"
        self.description = "Triggers when the star count of a specific repository changes"
        self.service = Service.GITHUB

    async def is_triggered(self, user, params) -> bool:
        try:
            github_infos = user['linked_to']['GITHUB']
            access_token = github_infos["access_token"]

            repo_owner = "Asti0s"
            repo_name = "ok"

            last_star_count = await DAO.get_user_github_repo_star_count(user['email'], repo_name)
            new_star_count = 0
            page = 1

            async with aiohttp.ClientSession() as session:
                headers = {
                    'Authorization': f'Bearer {access_token}',
                    'Accept': 'application/vnd.github+json',
                    'X-GitHub-Api-Version': '2022-11-28'
                }
                while True:
                    async with session.get(f'https://api.github.com/repos/{repo_owner}/{repo_name}/stargazers?page={page}', headers=headers) as response:
                        if response.status != 200:
                            raise Exception(f"GitHub API request failed with status {response.status}")
                        page_stargazers = await response.json()
                        if not page_stargazers:
                            break
                        new_star_count += len(page_stargazers)
                        page += 1

            if new_star_count != last_star_count:
                await DAO.set_user_github_repo_star_count(user['email'], repo_name, new_star_count)
                return True

            return False

        except Exception as error:
            print(f"An error occurred: {error}", flush=True)
            return False

class RepoForkCountUpdatedAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "Repo Fork Count Updated"
        self.description = "Triggers when the fork count of a specific repository changes"
        self.service = Service.GITHUB

    async def is_triggered(self, user, params) -> bool:
        try:
            github_infos = user['linked_to']['GITHUB']
            access_token = github_infos["access_token"]

            repo_owner = "NASA-SW-VnV"
            repo_name = "ikos"

            last_fork_count = await DAO.get_user_github_repo_fork_count(user['email'], repo_name)
            new_fork_count = 0
            page = 1

            async with aiohttp.ClientSession() as session:
                headers = {
                    'Authorization': f'Bearer {access_token}',
                    'Accept': 'application/vnd.github+json',
                    'X-GitHub-Api-Version': '2022-11-28'
                }
                while True:
                    async with session.get(f'https://api.github.com/repos/{repo_owner}/{repo_name}/forks?page={page}', headers=headers) as response:
                        if response.status != 200:
                            raise Exception(f"GitHub API request failed with status {response.status}")
                        page_forks = await response.json()
                        if not page_forks:
                            break
                        new_fork_count += len(page_forks)
                        page += 1

            if new_fork_count != last_fork_count:
                await DAO.set_user_github_repo_fork_count(user['email'], repo_name, new_fork_count)
                return True

            return False

        except Exception as error:
            print(f"An error occurred: {error}", flush=True)
            return False

class NewLikedTrackAction(IAction):
    def __init__(self):
        super().__init__()
        self.name = "New Liked Track"
        self.description = "Triggers when a new track is liked by the user."
        self.service = Service.SPOTIFY

    @staticmethod
    async def refresh_access_token(refresh_token: str):
        """
        Refresh Spotify access token using the provided refresh token.
        """
        try:
            token_url = "https://accounts.spotify.com/api/token"
            payload = {
                "grant_type": "refresh_token",
                "refresh_token": refresh_token,
                "client_id": Config.SPOTIFY_CLIENT_ID,
                "client_secret": Config.SPOTIFY_CLIENT_SECRET,
            }
            response = requests.post(token_url, data=payload)
            if response.status_code == 200:
                return response.json()["access_token"]
            else:
                print(f"Failed to refresh token: {response.status_code} {response.text}", flush=True)
                return None
        except Exception as e:
            print(f"Error refreshing token: {e}", flush=True)
            return None

    async def is_triggered(self, user, params) -> bool:
        try:
            # Retrieve Spotify user info
            spotify_infos = await DAO.find(get_database().spotify_users, "_id", user['linked_to']['spotify'])

            access_token = spotify_infos["token"]["access_token"]
            refresh_token = spotify_infos["token"]["refresh_token"]
            headers = {"Authorization": f"Bearer {access_token}"}

            # Attempt to check recently liked tracks
            response = requests.get(
                "https://api.spotify.com/v1/me/tracks?limit=1",
                headers=headers
            )

            if response.status_code == 401:  # Access token expired
                print("Access token expired, refreshing token...", flush=True)
                new_access_token = await NewLikedTrackAction.refresh_access_token(refresh_token)
                if new_access_token:
                    # Update access token in the database
                    await DAO.update(
                        get_database().spotify_users,
                        "_id",
                        spotify_infos["_id"],
                        {"token.access_token": new_access_token}
                    )
                    # Retry the original request with the new token
                    headers["Authorization"] = f"Bearer {new_access_token}"
                    response = requests.get(
                        "https://api.spotify.com/v1/me/tracks?limit=1",
                        headers=headers
                    )

            if response.status_code == 200:
                recent_track = response.json()["items"][0]["added_at"]
                now = datetime.utcnow()
                track_time = datetime.strptime(recent_track, "%Y-%m-%dT%H:%M:%SZ")
                delta = (now - track_time).total_seconds()

                return delta <= Config.AREA_CHECK_INTERVAL

            print(f"Failed to check liked tracks: {response.status_code} {response.text}", flush=True)
            return False
        except Exception as e:
            print(f"An error occurred: {e}", flush=True)
            return False
