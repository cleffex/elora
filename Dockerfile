# Use a base image with Python and required tools
FROM python:3.11-slim

# Set environment variables
ENV ODOO_RC /etc/odoo/odoo.conf
ENV DEBIAN_FRONTEND noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libpq-dev \
    git \
    curl \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel

# Create odoo user and group
RUN useradd -m -d /home/odoo -U -r -s /bin/bash odoo

# Clone your custom Odoo repository
RUN git clone --depth=1 https://github.com/cleffex/cleffex-crm /opt/odoo

# Set working directory
WORKDIR /opt/odoo

# Install Odoo dependencies
COPY requirements.txt /opt/odoo/
RUN pip install -r requirements.txt

# Copy custom configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Copy custom addons
COPY addons /mnt/extra-addons

# Create filestore directory and set permissions
RUN mkdir -p /home/odoo/.local/share/Odoo/filestore/cleffexauto && \
    chown -R odoo:odoo /opt/odoo /mnt/extra-addons /etc/odoo/odoo.conf /home/odoo


# Set permissions
RUN chown -R odoo:odoo /opt/odoo /mnt/extra-addons /etc/odoo/odoo.conf /home/odoo

# Expose the Odoo port
EXPOSE 8069

# Switch to the odoo user
USER odoo

# Optionally apply database migrations before starting Odoo
RUN python3 /opt/odoo/odoo-bin -c /etc/odoo/odoo.conf -u all --stop-after-init --without-demo=all



# Set the default command to start Odoo
CMD ["python3", "/opt/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]