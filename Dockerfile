FROM mcr.microsoft.com/playwright:v1.55.1-noble

# Install build dependencies for native Node.js modules (like ibm_db and oracledb)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Set execution defaults (headless and CI mode)
ENV HEADLESS=true
ENV CI=true

# Default command to execute the test suite
CMD ["npm", "run", "test"]
