# Use the official Frappe/ERPNext Docker image as the base
FROM frappe/erpnext:latest

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    python-is-python3 \
    python3-dev \
    python3-pip \
    redis-server \
    mariadb-client \
    xvfb \
    libfontconfig \
    wkhtmltopdf && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js (using nvm)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 18 && \
    npm install -g yarn

# Install Bench CLI
RUN pip install frappe-bench --break-system-packages

# Copy the CA certificate (if using SSL for the database)
COPY certs/ca.pem /etc/ssl/certs/ca.pem

# Set environment variables
ENV DB_HOST=erpnext-mysql-na9ib-3939.g.aivencloud.com
ENV DB_PORT=22482
ENV DB_NAME=defaultdb
ENV DB_PASSWORD=AVNS_O-TpO6UuJ9dR8QATMfq
ENV DB_SSL_CA=/etc/ssl/certs/ca.pem
ENV ADMIN_PASSWORD=1411$7552

# Initialize ERPNext
RUN bench init erpnext && \
    cd erpnext && \
    bench new-site your-site-name --db-host=${DB_HOST} --db-port=${DB_PORT} --db-name=${DB_NAME} --db-password=${DB_PASSWORD} --admin-password=${ADMIN_PASSWORD}

# Get the ERPNext app
RUN cd erpnext && \
    bench get-app https://github.com/frappe/erpnext && \
    bench --site your-site-name install-app erpnext

# Start ERPNext
CMD ["bench", "start"]
