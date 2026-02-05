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

# Precompile assets (needs dummy secret)
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile

# Create startup script with logging
RUN echo '#!/bin/bash\n\
set -e\n\
echo "=== Starting hr-intranet ==="\n\
echo "RAILS_ENV=$RAILS_ENV"\n\
echo "PORT=$PORT"\n\
echo "DATABASE_URL is set: $(if [ -n \"$DATABASE_URL\" ]; then echo yes; else echo no; fi)"\n\
echo "Running migrations..."\n\
bundle exec rails db:migrate 2>&1 || echo "Migration failed or not needed"\n\
echo "Starting Rails server on port ${PORT:-3000}..."\n\
exec bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}\n\
' > /myapp/start.sh && chmod +x /myapp/start.sh

CMD ["/myapp/start.sh"]
