FROM alpine as build

RUN apk --update upgrade && \
    apk add --no-cache --virtual=temporary curl gcc make build-base && \
    curl -o /tmp/iozone.tar http://www.iozone.org/src/current/iozone3_506.tar && \
    cd /tmp && \
    tar -xf /tmp/iozone.tar && \
    cd /tmp/iozone*/src/current && \
    make clean && \
    make linux-AMD64

FROM alpine
LABEL maintainer="1101010@gmail.com" \
    izone_version="3.506"

RUN adduser -S -u 11010 iozone && \
    mkdir /data && \
    chmod 777 /data

COPY --from=build /tmp/iozone3_506/src/current/iozone /usr/bin/iozone

WORKDIR /data
USER 11010

ENTRYPOINT ["/usr/bin/iozone"]
CMD ["-e","-I","-a","-s","100M","-r","4k","-i","0","-i","1","-i","2"]
