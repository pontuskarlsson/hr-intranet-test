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

# Simple startup - just run Rails
# Assets will compile on first request (config.assets.compile = true)
CMD ["sh", "-c", "echo '=== Starting Rails ===' && echo \"PORT=$PORT\" && bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}"]
