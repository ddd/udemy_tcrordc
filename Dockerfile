# Rails Application Specific Dockerfile
#
# VERSION		0.0.3

FROM deryldowney/rails:4.2.6

MAINTAINER 'D Deryl Downey <ddd@deryldowney.com>'

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

# Ensure basic tools, and git are installed
RUN apt-get install -y apt-utils dialog git git-extras git-flow gnupg2 less net-tools openssh-server traceroute

# Lets now grab our app and make sure our non-priv user owns it
WORKDIR /usr/src/app
RUN git clone https://github.com/ddd/udemy_tcrordc.git udemy
RUN chown -R cstg:cstg udemy

# Change the WORKDIR to the app so all commands apply within it's directory
WORKDIR /usr/src/app/udemy
RUN bundle install && bundle --version && ruby --version && bundle exec rails --version && bundle exec rspec --version

# Change to the CSTG user created in the base image
USER cstg
RUN /bin/bash -l -c "whoami && groups && pwd"

# At this point, we are ready to configure our database connection, run our tests, and/or develop!
# Put the necessary commands below here as 'RUN' commands. They'll be executed within the context
# of the user 'cstg'
RUN echo "ALERT: Image pre-load is complete!"

# Add a health check to make sure the image is still working when its actively running
# NOTE: This ONLY works with Docker v1.12+.
#HEALTHCHECK --interval=5m --timeout=5s \
#  CMD curl -f http://localhost:3000/ || exit 1

# Expose required ports
EXPOSE 22 3000

# Set the ENTRYPOINT for the created image
ENTRYPOINT exec rails s

# Set the default command for the created image
#CMD /bin/bash --login
CMD ["-p", "3000", "-b", "0.0.0.0"]

