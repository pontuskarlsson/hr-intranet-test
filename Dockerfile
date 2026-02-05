FROM ruby:2.5.7

# Fix for EOL Debian Buster - use archived repos
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /myapp
WORKDIR /myapp

COPY . /myapp

RUN bundle install

# Set environment for logging
ENV RAILS_LOG_TO_STDOUT=enabled
ENV RAILS_SERVE_STATIC_FILES=enabled

# Make entrypoint executable
RUN chmod +x /myapp/docker-entrypoint.sh

ENTRYPOINT ["/myapp/docker-entrypoint.sh"]
