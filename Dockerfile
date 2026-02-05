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

# Startup script with full error output
RUN printf '#!/bin/bash\n\
set -x\n\
echo "PORT=$PORT"\n\
echo "RAILS_ENV=$RAILS_ENV"\n\
echo "DATABASE_URL set: $(test -n "$DATABASE_URL" && echo yes || echo no)"\n\
echo "Starting Rails..."\n\
exec bundle exec rails server -b 0.0.0.0 -p $PORT 2>&1\n\
' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
