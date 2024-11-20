from os import getenv
from dotenv import load_dotenv

load_dotenv()

JWT_SECRET_KEY = getenv('JWT_SECRET_KEY', 'Default')
MONGO_URI = getenv('MONGO_URI', 'Default')
