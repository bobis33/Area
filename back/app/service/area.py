from inspect import getmembers

from .areaComponents import IAction, IReaction
from app.service import actions, reactions


async def get_actions_service():
    result = []

    action_members = getmembers(actions)
    for action_member in action_members:
        if isinstance(action_member[1], type) and issubclass(action_member[1], IAction) and action_member[0] != "IAction":
            result.append(action_member[1]())

    return result

async def get_reactions_service():
    result = []

    reaction_members = getmembers(reactions)
    for reaction_member in reaction_members:
        if isinstance(reaction_member[1], type) and issubclass(reaction_member[1], IReaction) and reaction_member[0] != "IReaction":
            result.append(reaction_member[1]())

    return result

async def get_actions_by_field(field, value):
    result = []

    actions2 = await get_actions_service()
    for action in actions2:
        if getattr(action, field) == value:
            result.append(action)

    return result

async def get_reactions_by_field(field, value):
    result = []

    reactions2 = await get_reactions_service()
    for reaction in reactions2:
        if getattr(reaction, field) == value:
            result.append(reaction)

    return result
