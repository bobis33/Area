from enum import Enum

class Service(Enum):
    AREA = "Area"
    GMAIL = "GMail"
    DISCORD = "Discord"
    GITHUB = "Github"

class IAction:
    def __init__(self):
        self.name = "IAction"
        self.description = "No description where provided"
        self.service = Service.AREA

    async def is_triggered(self, user) -> bool:
        if user is None:
            return False
        return True

class IReaction:
    def __init__(self):
        self.name = "IReaction"
        self.description = "No description where provided"
        self.service = Service.AREA

    async def react(self, user):
        print(f"IReaction was triggered for user {user['username']}")
