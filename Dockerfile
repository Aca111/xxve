FROM debian:latest
LABEL version="0.2"
EXPOSE 80
# Install dependencies
 
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install --no-install-recommends curl unzip jq openssl qrencode unzip tzdata ca-certificates nginx
RUN apt-get -y clean

# Install X-core

#RUN curl -s -L -H "Cache-Control: no-cache" -o /tmp/xry.zip https://git.sr.ht/~bak96/xrydkr/blob/master/xry.zip && \
#    sudo unzip /tmp/xry.zip -d / && \
#    sudo chmod +x /usr/bin/xray && \
#    sudo chmod +x /etc/init.d/xray
#end 

#install xry-install
#WORKDIR /home
#COPY install.sh .
#COPY default.json .
#RUN sudo sh install.sh 
CMD nginx -g "daemon off;"
#RUN qrencode -s 50 -o qr.png $(cat test.url)
#end 

VOLUME /etc/xray
ENV TZ='Asia/Tehran'
#CMD [ "/usr/bin/xray", "run", "-config", "/etc/xray/config.json" ]
