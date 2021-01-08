FROM alpine:3.12.3
RUN apk add --no-cache bison gperf build-base perl bash
WORKDIR /src
COPY *.c *.h keywords.gperf parser.y version_opt_gen.pl Makefile Makefile.in configure configure.in config.h.in  /src/
COPY docker_restart.sh /src/
# Ensure parser.c is regenerated
RUN rm -f parser.c
RUN sh configure
RUN make clean
RUN time make -j 2
RUN chmod u+x docker_restart.sh
EXPOSE 7777
ENTRYPOINT ./docker_restart.sh /cores/$CORE_TO_LOAD
