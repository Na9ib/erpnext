FROM frappe/erpnext:latest

# Set environment variables
ENV DB_HOST=erpnext-mysql-na9ib-3939.g.aivencloud.com
ENV DB_PORT=22482
ENV DB_NAME=defaultdb
ENV DB_PASSWORD=AVNS_O-TpO6UuJ9dR8QATMfq
ENV DB_SSL_CA=/etc/ssl/certs/ca.pem
ENV ADMIN_PASSWORD=1411$7552

# Copy the CA certificate
COPY certs/ca.pem /etc/ssl/certs/ca.pem

# Start ERPNext
CMD ["bench", "start"]
