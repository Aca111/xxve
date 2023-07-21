FROM alpine
LABEL version="0.2"
EXPOSE 80
# Install dependencies
 
RUN apk update
RUN apk upgrade
RUN apk add curl unzip jq openssl libqrencode unzip tzdata
RUN rm -rf /var/lib/apk/lists/*


# Install X-core

RUN curl -L -H "Cache-Control: no-cache" -o /tmp/xry.zip https://git.sr.ht/~bak96/xrydkr/blob/master/xry.zip && \
    unzip /tmp/xry.zip -d / && \
    chmod +x /usr/bin/xray
#end 

#install xry-install
#WORKDIR /home
COPY install.sh .
#COPY default.json .
RUN sh install.sh 
RUN qrencode -s 50 -o qr.png $(cat test.url)
#end 
ENTRYPOINT ["tail", "-f", "/dev/null"]
