"""Module that contain all the environment variables"""

import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URI=os.getenv('MONGO_URI', 'Default')
JWT_SECRET_KEY=os.getenv('JWT_SECRET_KEY', 'Default')
