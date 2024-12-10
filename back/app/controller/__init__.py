from .auth import router as auth_router
from .area import router as area_router
from .users import router as users_router
from .about import router as about_router

def register_router(app):
    app.include_router(auth_router, prefix="/auth")
    app.include_router(area_router, prefix="/area")
    app.include_router(users_router, prefix="/users")
    app.include_router(about_router)
