# IA 462 Midterm - Attempt at a hardened dockerfile


#***************************************************************
# Layer 1 - Using a secure image to build the Docker container:
#***************************************************************


# Using a known, secure SHA256 hash baseline for builder:

FROM python:3.15-slim@sha256:65a65fc7b30b06cb6df4930fd4650697cb23f4c2698ab81fc87e4b031bc36928 AS builder


# General descriptions & labels:

LABEL maintainer="afortun5@emich.edu"
LABEL version="1.0"
LABEL description="IA 462 Midterm Attempt"



#Mandated copy requirements for final deliverables and functionality:

WORKDIR /build
COPY requirements.lock .



#Package installation requirements:

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir --require-hashes -r requirements.lock


#*NOTE: ENV PATH="/opt/venv/bin:$PATH" is very important because this defines the isolated path for all installed packages.
#       Doing this will isolated all of builder instructions from executed unnecessary packages when initiating runtime.



#***************************************
# Layer 2 - Initiates the runtime image:
#***************************************


# Utilizing the same SHA256 digest from the builder phase for the runtime phase:

FROM python:3.15-slim@sha256:65a65fc7b30b06cb6df4930fd4650697cb23f4c2698ab81fc87e4b031bc36928 AS runtime


#Creates a non-root user:

RUN groupadd --system appgroup && \
    useradd  --system --gid appgroup --home /app --shell /usr/sbin/nologin appuser


#Applying venv to the directory path:

ENV PATH="/opt/venv/bin:$PATH"


#Copy requirements - Queries the builder to forwards the directory path to the appuser of appgroup & assigning them ownership of app/ ./app/.:

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appgroup app/ ./app/




#Applying rights and permissions to a non-root user for Docker container access:
USER appuser
EXPOSE 5000
CMD ["python3", "app/app.py"]
