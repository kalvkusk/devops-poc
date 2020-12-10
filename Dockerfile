FROM phusion/passenger-full:1.0.12
ENV APP=/home/app/webapp
ENV HOME /root

RUN rm /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down

ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN mkdir /home/app/webapp
COPY --chown=app:app . $APP

# Update apt
RUN apt-get update -y
# Install Pip
RUN apt install -y python3-pip
# Install python app requirements
RUN pip3 install -r $APP/requirements.txt

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80

CMD ["/sbin/my_init"]
