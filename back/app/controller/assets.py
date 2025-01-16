import os
from fastapi.responses import FileResponse
from fastapi import APIRouter, HTTPException

router = APIRouter()

@router.get("/assets/{file_path:path}")
async def get_asset(file_path: str):
    """
    Public endpoint to get assets
    """
    file_full_path = os.path.join('app/assets', file_path)
    if os.path.exists(file_full_path):
        return FileResponse(file_full_path)

    raise HTTPException(status_code=404, detail="Asset not found")
