"""
FELDOR_HEALTH - Vercel Serverless Entry Point
This file MUST be at /api/index.py for Vercel to execute it
"""
import sys
import os

# Add the backend directory to Python path
backend_path = os.path.join(os.path.dirname(__file__), '..', 'backend')
sys.path.insert(0, backend_path)

# Import and expose the FastAPI app
from backend.main import app

# 'app' is the ASGI handler Vercel will call
