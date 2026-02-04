FROM ruby:2.5.7                                                                                                                                       
                                                                                                                                                     
# Fix for EOL Debian Buster - use archived repos                                                                                                      
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \                                                                         
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \                                                                    
    sed -i '/buster-updates/d' /etc/apt/sources.list                                                                                                  
                                                                                                                                                      
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs                                                                         
                                                                                                                                                      
RUN mkdir /myapp                                                                                                                                      
WORKDIR /myapp                                                                                                                                        
                                                                                                                                                      
COPY Gemfile /myapp/Gemfile                                                                                                                           
COPY Gemfile.lock /myapp/Gemfile.lock                                                                                                                 
RUN bundle install                                                                                                                                    
                                                                                                                                                      
COPY . /myapp                                                                                                                                         
                                                                                                                                                      
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"] 
