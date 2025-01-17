from importlib import import_module
from fastapi_utils.tasks import repeat_every

from app.fast import app
from app.database.Dao import DAO
from .area import get_actions_by_field, get_reactions_by_field

from app.config import Config

@app.on_event("startup")
@repeat_every(seconds=Config.AREA_CHECK_INTERVAL)
async def update_actions():
    areas = await DAO.find_all_areas()
    for area in areas:
        try:
            action_func = (await get_actions_by_field("name", area["action"]))[0].is_triggered
            reaction_func = (await get_reactions_by_field("name", area["reaction"]))[0].react

            for username in area["subscribed_users"]:
                try:
                    user = await DAO.find_user_by_username(username)
                    if await action_func(user, area["action_params"]):
                        await reaction_func(user, area["reaction_params"])
                except Exception as e:
                    print(f"Error triggering a/rea for user {username}: {e}\n", flush=True)

        except AttributeError:
            print(f"Reaction {area['reaction']} not found\n", flush=True)
        except Exception as e:
            print(e, flush=True)
