"""FastApi application configuration class"""

import os

# load variables from .env files
from dotenv import load_dotenv
load_dotenv()

class Config:
    """Base application configuration class"""

    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'Default')
    MONGO_URI = os.getenv('MONGO_URI', 'AREAdatabase')

    GOOGLE_CLIENT_ID = os.getenv('GOOGLE_CLIENT_ID', 'None')
    GOOGLE_CLIENT_SECRET = os.getenv('GOOGLE_CLIENT_SECRET', 'None')
    GOOGLE_SERVER_METADATA_URL = os.getenv('GOOGLE_SERVER_METADATA_URL', 'None')
    GOOGLE_CLIENT_KWARGS = {'scope': 'openid email profile https://www.googleapis.com/auth/gmail.send https://www.googleapis.com/auth/gmail.compose https://www.googleapis.com/auth/gmail.readonly'}

    GITHUB_CLIENT_ID = os.getenv('GITHUB_CLIENT_ID', 'None')
    GITHUB_CLIENT_SECRET = os.getenv('GITHUB_CLIENT_SECRET', 'None')

    DISCORD_CLIENT_ID = os.getenv('DISCORD_CLIENT_ID', 'None')
    DISCORD_CLIENT_SECRET = os.getenv('DISCORD_CLIENT_SECRET', 'None')
    DISCORD_BOT_TOKEN = os.getenv('DISCORD_BOT_TOKEN', 'None')

    SPOTIFY_CLIENT_ID = os.getenv('SPOTIFY_CLIENT_ID', 'None')
    SPOTIFY_CLIENT_SECRET = os.getenv('SPOTIFY_CLIENT_SECRET', 'None')

    GITLAB_CLIENT_ID = os.getenv('GITLAB_CLIENT_ID', 'None')
    GITLAB_CLIENT_SECRET = os.getenv('GITLAB_CLIENT_SECRET', 'None')

    TWITCH_CLIENT_ID = os.getenv('TWITCH_CLIENT_ID', 'None')
    TWITCH_CLIENT_SECRET = os.getenv('TWITCH_CLIENT_SECRET', 'None')

    YOUTUBE_API_KEY = os.getenv('YOUTUBE_API_KEY', 'None')

    MIDDLEWARE_SECRET_KEY = os.getenv('MIDDLEWARE_SECRET_KEY', 'Default')

    AREA_CHECK_INTERVAL = int(os.getenv('AREA_CHECK_INTERVAL', '10'))

    FRONTEND_URL = os.getenv('FRONTEND_URL', 'None')
    MOBILE_URL = os.getenv('MOBILE_URL', 'None')
