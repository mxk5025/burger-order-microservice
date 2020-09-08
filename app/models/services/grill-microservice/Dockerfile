FROM ruby:2.6.3

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN mkdir -p /app
RUN mkdir -p /usr/local/nvm
WORKDIR /app

RUN gem install aws-sdk
RUN gem install dotenv
RUN gem install http
RUN gem install json

# Copy the main application.
COPY . ./

# The main command to run when the container starts
CMD ["ruby", "grill.rb"]