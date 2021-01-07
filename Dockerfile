FROM alpine:3.12.3
RUN apk add --no-cache bison gperf build-base
COPY . .
RUN sh configure 
RUN time make -j 2
RUN rm -rf db-cores
EXPOSE 7777
ENTRYPOINT echo $CORE_TO_LOAD ;  ./docker_restart.sh /cores/$CORE_TO_LOAD
