FROM alpine:latest

ADD package /sharedir

RUN cd /sharedir ; sh init.sh ; rm -fv install.sh init.sh

CMD ["bash","run_samba"]
