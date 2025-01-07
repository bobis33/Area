"""FastApi application configuration class"""

import os

# load variables from .env files
from dotenv import load_dotenv
load_dotenv()

class Config:
    """Base application configuration class"""

    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'Default')
    MONGO_URI = os.getenv('MONGO_URI', 'area')

    GOOGLE_CLIENT_ID = os.getenv('GOOGLE_CLIENT_ID', 'None')
    GOOGLE_CLIENT_SECRET = os.getenv('GOOGLE_CLIENT_SECRET', 'None')
    GOOGLE_SERVER_METADATA_URL = os.getenv('GOOGLE_SERVER_METADATA_URL', 'None')
    GOOGLE_CLIENT_KWARGS = {'scope': 'openid email profile https://www.googleapis.com/auth/gmail.send https://www.googleapis.com/auth/gmail.compose https://www.googleapis.com/auth/gmail.readonly'}

    YOUTUBE_API_KEY = os.getenv('YOUTUBE_API_KEY', 'None')

    MIDDLEWARE_SECRET_KEY = os.getenv('MIDDLEWARE_SECRET_KEY', 'Default')

    AREA_CHECK_INTERVAL = int(os.getenv('AREA_CHECK_INTERVAL', "10"))
    FRONTEND_URL = os.getenv('FRONTEND_URL', "http://localhost:8081")
