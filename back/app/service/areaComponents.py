from enum import Enum

class Service(Enum):
    AREA = "Area"
    GMAIL = "GMail"
    DISCORD = "Discord"
    GITHUB = "Github"
    SPOTIFY = "Spotify"
    GITLAB = "Gitlab"
    TIME = "Time"

class IAction:
    def __init__(self):
        self.name = "IAction"
        self.description = "No description where provided"
        self.service = Service.AREA

    async def get_params(self):
        return {}

    async def is_triggered(self, user, params) -> bool:
        if user is None:
            return False
        return True

class IReaction:
    def __init__(self):
        self.name = "IReaction"
        self.description = "No description where provided"
        self.service = Service.AREA

    async def get_params(self):
        return {}

    async def react(self, user, params):
        print(f"IReaction was triggered for user {user['username']} with params {params}")
