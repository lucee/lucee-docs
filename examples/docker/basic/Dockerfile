FROM lucee/lucee:6.1.0.175-BETA

# Provide test page by creating the directory and copying files
RUN mkdir -p /var/www
COPY www/ /var/www/

# how to build it
# docker build -t lucee-basic .

# how to run it (provides port for nginx and tomcat (optional); Lucee admin password)
# docker run -d -p 8054:80 -p 8854:8888 -e LUCEE_ADMIN_PASSWORD=qwerty lucee-basic