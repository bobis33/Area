from importlib import import_module

from app.fast import app
from app.database.Dao import DAO
from fastapi_utils.tasks import repeat_every

action_mod = import_module("app.service.actions")
reaction_mod = import_module("app.service.reactions")

@app.on_event("startup")
@repeat_every(seconds=100)
async def update_actions():
    areas = await DAO.find_all_areas()
    for area in areas:
        try:
            action_func = getattr(action_mod, area["action"])
            reaction_func = getattr(reaction_mod, area["reaction"])

            if await action_func():
                await reaction_func()
        except AttributeError:
            print(f"Reaction {area['reaction']} not found\n", flush=True)
        except Exception as e:
            print(e, flush=True)
