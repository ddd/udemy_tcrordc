# Rails Application Specific Dockerfile
#
# VERSION		v0.0.1

FROM deryldowney/docker-rails

MAINTAINER 'D Deryl Downey <ddd@deryldowney.com>'

LABEL Description="Udemy.com - The Complete Ruby On Rails Developer Course - Dockerized Testing" \
      Vendor="D Deryl Downey" \
      Version="v0.0.1"

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

# Lets now grab our app and make sure our non-priv user owns it
WORKDIR /usr/src/app
RUN git clone https://github.com/ddd/udemy_tcrordc.git udemy
RUN chown -R cstg:cstg udemy

# Change the WORKDIR to the app so all commands apply within it's directory
WORKDIR /usr/src/app/udemy
RUN bundle install && bundle --version && ruby --version && bundle exec rails --version && bundle exec rspec --version

# Expose required ports
EXPOSE 3000

# Set the ENTRYPOINT for the created image
USER cstg
#RUN bundle exec rspec spec

CMD ["/bin/bash", "-l"]

