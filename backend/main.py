"""
FELDOR_HEALTH - Main Application (Vercel Compatible)
Production-ready FastAPI backend for healthcare AI platform
"""
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import logging
import os
import time

from app.core.config import settings
from app.models.database import init_db
from app.routers import breast, cervical

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title=settings.APP_NAME,
    description="AI-assisted cancer detection platform for breast and cervical cancer screening",
    version=settings.APP_VERSION,
    docs_url="/api/docs",
    redoc_url="/api/redoc"
)

# CORS - Allow all origins for Vercel deployment
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request timing middleware
@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = str(process_time)
    return response

# Include routers
app.include_router(breast.router)
app.include_router(cervical.router)

# Static files (for local dev only - Vercel handles frontend separately)
os.makedirs("uploads", exist_ok=True)

@app.on_event("startup")
async def startup_event():
    """Initialize database on startup"""
    logger.info(f"Starting {settings.APP_NAME} v{settings.APP_VERSION}")
    try:
        init_db()
        logger.info("Database initialized")
    except Exception as e:
        logger.warning(f"Database init warning: {e}")

@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "app": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "timestamp": time.time()
    }

@app.get("/api/stats")
async def platform_stats():
    """Get overall platform statistics"""
    return {
        "modules": ["breast", "cervical"],
        "supported_formats": list(settings.ALLOWED_EXTENSIONS),
        "models": {
            "breast": ["breast_v1", "breast_v2"],
            "cervical": ["cervical_v1"]
        },
        "features": [
            "DICOM support",
            "AI heatmap overlay",
            "Lesion localization",
            "Cell-level detection",
            "Clinician review workflow",
            "Audit logging"
        ]
    }
