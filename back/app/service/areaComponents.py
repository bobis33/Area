from enum import Enum

class Service(Enum):
    AREA = "Area"
    GMAIL = "GMail"

class IAction:
    def __init__(self):
        self.name = "IAction"
        self.description = "No description where provided"
        self.service = Service.AREA

    def is_triggered(self, user) -> bool:
        if user is None:
            return False
        return True

class IReaction:
    def __init__(self):
        self.name = "IReaction"
        self.description = "No description where provided"
        self.service = Service.AREA

    def react(self, user):
        print(f"IReaction was triggered for user {user['username']}")
