from .about import router as about_router
from .area import router as area_router
from .assets import router as assets_router
from .auth import router as auth_router
from .oauth import router as oauth_router
from .oauthLink import router as oauth_link_router
from .users import router as users_router


def register_router(app):
    app.include_router(auth_router, prefix="/auth")
    app.include_router(oauth_router, prefix="/auth")
    app.include_router(oauth_link_router, prefix="/auth")
    app.include_router(area_router, prefix="/area")
    app.include_router(users_router, prefix="/users")
    app.include_router(assets_router)
    app.include_router(about_router)
