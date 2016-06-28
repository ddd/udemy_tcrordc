# Rails Application Specific Dockerfile
#
# VERSION		0.0.2

FROM deryldowney/docker-rails

MAINTAINER 'D Deryl Downey <ddd@deryldowney.com>'

LABEL Description="Udemy.com - The Complete Ruby On Rails Developer Course - Dockerized Testing" \
      Vendor="D Deryl Downey" \
      Version="0.0.2"

# # # # # # # # # #
#  NOTICE NOTICE  #
# # # # # # # # # #
#
# This is where we would start injecting per-application build files and commands. 
# In the end, the reason for this Dockerfile is to configure a running, dockerized application
# So, lets get going! - ddd

# Ensure we are root
USER root

# Environment vars go here
ENV TERM xterm
ENV TTY=$(tty)

# Lets now install our editor, grab our app, and make sure our non-priv user owns it
WORKDIR /usr/src/app
RUN apt-get install vim vim-scripts \
    && clone https://github.com/ddd/udemy_tcrordc.git udemy \
    && chown -R cstg:cstg udemy

# Change the WORKDIR to the app so all commands apply within it's directory
WORKDIR /usr/src/app/udemy
RUN bundle install && bundle --version && ruby --version && bundle exec rails --version && bundle exec rspec --version

# Expose required ports
EXPOSE 22 3000

# Set the ENTRYPOINT for the created image
USER cstg

# NOTICE: You need to configure your config/database.yml BEFORE you uncomment the following line.
#	  It WILL fail on a database error until you do! This image comes pre-configured for PostgreSQL.
#	  This image uses a local environment variable to define the password for the assigned user.
#	  Set 'UDEMY_TCRORDC_DATABASE_USER', 'UDEMY_TCRORDC_DATABASE_PASSWORD', and UDEMY_TCRORDC_DATABASE_HOST
#	  here. The database.yml is already configured to use them.
#
#	  **NOTE: While the config/database.yml uses localhost as the database host server, this image DOES NOT
#		  have a PostgreSQL server instance installed. You WILL have to provide that service.

# Database environment variables. Uncomment and change.
#ENV UDEMY_TCRORDC_DATABASE_USER='cstg'
#ENV UDEMY_TCRORDC_DATABASE_PASSWORD='cstguser'
#ENV UDEMY_TCRORDC_DATABASE_HOST='localhost'

# Set up the above environment, then uncomment the following and comment out the CMD.
#RUN bundle exec rake db:create:all && bundle exec rake db:test:prepare && bundle exec rspec spec

# Make the image usable until the above environmental requirements are met.
CMD ["/bin/bash", "-l"]

