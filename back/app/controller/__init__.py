from .auth import router as auth_router

def register_router(app):
    app.include_router(auth_router, prefix="/auth")
