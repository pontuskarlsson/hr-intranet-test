FROM ruby:2.5.7

# Fix for EOL Debian Buster - use archived repos
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /myapp
WORKDIR /myapp

# Copy everything first (vendor/extensions needed for bundle install)
COPY . /myapp

RUN bundle install

# Precompile assets for production
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=dummy_for_asset_precompilation
RUN bundle exec rails assets:precompile

# Clear dummy secret (will be set at runtime)
ENV SECRET_KEY_BASE=

CMD bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}
