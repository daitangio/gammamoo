FROM alpine:3.12.3
RUN apk add --no-cache bison gperf build-base
COPY . .
RUN sh configure && make -j 2
RUN rm -rf db-cores
EXPOSE 7777
ENTRYPOINT echo $CORE_TO_LOAD ;  ./moo /cores/$CORE_TO_LOAD /cores/$CORE_TO_LOAD.new
