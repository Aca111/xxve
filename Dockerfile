FROM alpine:latest
LABEL version="1.1"
EXPOSE 80

# Install dependencies

RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl unzip jq openssl libqrencode unzip tzdata ca-certificates nginx bash nano openssh
RUN echo -e "PermitRootLogin yes \nUsePam yes \nPort 3312 \nPasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo 'root:d7ba24#87db411e23%09d6$81@' | chpasswd

#end

# Install X-core

RUN curl -s -L -H "Cache-Control: no-cache" -o /tmp/xry.zip https://git.sr.ht/~bak96/xrydkr/blob/master/xry.zip && \
    unzip /tmp/xry.zip -d / && \
    chmod +x /usr/bin/xray && \
    chmod +x /etc/init.d/xray

#end 

#install xry-install

#WORKDIR ~/
COPY install.sh .
COPY default.json .
RUN sh install.sh 
CMD [nginx -g 'daemon off;']
ENV TZ='Asia/Tehran'

#end

#VOLUME /etc/xray
#RUN qrencode -s 50 -o qr.png $(cat test.url)
#CMD [ "/usr/bin/xray", "-config", "/etc/xray/config.json" ]
#CMD ["/bin/netstat", "-tupln"]
