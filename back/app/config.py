"""FastApi application configuration class"""

import os

# load variables from .env files
from dotenv import load_dotenv
load_dotenv()

class Config:
    """Base application configuration class"""

    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY', 'Default')
    MONGO_URI = os.getenv('MONGO_URI', 'AREAdatabase')
