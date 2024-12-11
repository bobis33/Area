"""Module that implements commonly used security functionality
"""

from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from fastapi_jwt_auth import AuthJWT
from fastapi_jwt_auth.exceptions import AuthJWTException

from functools import wraps

auth_scheme = HTTPBearer()

class TokenManager:
    """A class to manage tokens
    """
    @staticmethod
    def verify_token(token: AuthJWT):
        """verify if a token is valid

        Args:
            token (AuthJWT): the token to be verified.

        Raises:
            HTTPException: raise a 401 error if the token is invalid
        """
        try:
            token.jwt_required()
        except AuthJWTException as e:
            raise HTTPException(status_code=401, detail=f"Invalid token") from e

    @staticmethod
    def get_token_subject(token: AuthJWT):
        """verify the given token and get the token subject

        Args:
            token (AuthJWT): the token to extract the subject from.

        Returns:
            str: the token subject.
        """
        return token.get_jwt_subject()

def secure_endpoint(func):
    """Decorator to easily secure endpoints by adding token verification and subject retrieval automatically."""
    @wraps(func)
    async def wrapper(*args, token: HTTPAuthorizationCredentials = None, **kwargs):
        if not token:
            raise HTTPException(status_code=401, detail="Token is missing")

        authorize = AuthJWT()
        authorize._token = token.credentials  # Assign token credentials to the AuthJWT instance
        TokenManager.verify_token(authorize)
        kwargs['token'] = authorize

        # Call the wrapped function with the updated kwargs
        return await func(*args, **kwargs)

    return wrapper
