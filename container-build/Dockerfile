FROM registry.access.redhat.com/ubi8/ubi:8.0 ❶
MAINTAINER Red Hat Training <training@redhat.com>

# DocumentRoot for Apache
ENV DOCROOT=/var/www/html ❷

RUN yum install -y --no-docs --disableplugin=subscription-manager httpd && \ ❸
    yum clean all --disableplugin=subscription-manager -y && \
    echo "Hello from the httpd-parent container!" > ${DOCROOT}/index.html

# Allows child images to inject their own content into DocumentRoot
ONBUILD COPY src/ ${DOCROOT}/  ❹

EXPOSE 80

# This stuff is needed to ensure a clean start
RUN rm -rf /run/httpd && mkdir /run/httpd

# Run as the root user
USER root ❺

# Launch httpd
CMD /usr/sbin/httpd -DFOREGROUND
