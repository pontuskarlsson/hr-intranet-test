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
                                                                                                                                                       
CMD bundle exec rails server -b 0.0.0.0 -p ${PORT:-3000}
