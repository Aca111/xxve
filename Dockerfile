FROM alpine:latest
LABEL version="1.1"
EXPOSE 80

# Install dependencies

RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl unzip jq openssl libqrencode unzip tzdata ca-certificates nginx bash nano openssh openrc
RUN echo -e "PermitRootLogin yes \nPort 3312 \nPasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo 'root:d7ba24#87db411e23%09d6$81@' | chpasswd

#end

# Install X-core

RUN curl -s -L -H "Cache-Control: no-cache" -o /tmp/xry.zip https://git.sr.ht/~bak96/xrydkr/blob/master/xry.zip && \
    unzip /tmp/xry.zip -d / && \
    chmod +x /usr/bin/xray && \
    chmod +x /etc/init.d/xray

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh
    
#end 

#install xry-install

ENV TZ='Asia/Tehran'
WORKDIR ~/
COPY install.sh .
COPY default.json .
RUN rc-status \
    # touch softlevel because system was initialized without openrc
    && touch /run/openrc/softlevel \
    && rc-service sshd start
RUN sh install.sh 
CMD ["nginx", "-g", "daemon off;"]

#end

#VOLUME /etc/xray
#RUN qrencode -s 50 -o qr.png $(cat test.url)
#CMD [ "/usr/bin/xray", "-config", "/etc/xray/config.json" ]
#CMD ["/bin/netstat", "-tupln"]
