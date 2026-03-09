FROM nginx:alpine

LABEL author="DevOps Team" \
      version="1.0" \
      description="Custom Nginx Web Server"

# Copy custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy HTML content
COPY index.html /usr/share/nginx/html/index.html

# Create non-root user for security
RUN addgroup -g 1001 -S nginx && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx \
    -s /sbin/nologin -c "Nginx user" -G nginx nginx

# Set permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Switch to nginx user
USER nginx

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
