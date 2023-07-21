FROM alpine
LABEL version="0.2"
EXPOSE 80
# Install dependencies
 
RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl unzip jq openssl libqrencode unzip tzdata ca-certificates nginx

# Install X-core

RUN curl -s -L -H "Cache-Control: no-cache" -o /tmp/xry.zip https://git.sr.ht/~bak96/xrydkr/blob/master/xry.zip && \
    unzip /tmp/xry.zip -d / && \
    chmod +x /usr/bin/xray && \
    chmod +x /etc/init.d/xray
#end 

#install xry-install
#WORKDIR /home
COPY install.sh .
COPY default.json .
RUN sh install.sh 
CMD nginx -g "daemon off;"
#RUN qrencode -s 50 -o qr.png $(cat test.url)
#end 

VOLUME /etc/xray
ENV TZ='Asia/Tehran'
CMD [ "/usr/bin/xray", "run", "-config", "/etc/xray/config.json" ]
