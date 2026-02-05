FROM ruby:2.5.7

# Fix for EOL Debian Buster - use archived repos
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile Gemfile.lock /myapp/
RUN bundle install

# Cache bust - change this to force rebuild: v2
COPY . /myapp

# Precompile assets (needs dummy secret)
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production bundle exec rails assets:precompile

# Create startup script
RUN printf '#!/bin/bash\nset -e\necho "=== Starting hr-intranet ==="\necho "RAILS_ENV=$RAILS_ENV"\necho "PORT=$PORT"\nbundle exec rails db:migrate 2>&1 || echo "Migration skipped"\necho "Starting server..."\nexec bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}\n' > /myapp/start.sh && chmod +x /myapp/start.sh

CMD ["/myapp/start.sh"]
