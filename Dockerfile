FROM debian:9 as BUILD
RUN apt-get update -y && apt-get upgrade -y && apt-get install build-essential libevent-dev libssl-dev wget -y
RUN mkdir -p /opt/proxy
WORKDIR /opt/proxy
RUN wget https://github.com/z3APA3A/3proxy/archive/0.8.12.tar.gz
RUN tar zxvf 0.8.12.tar.gz
WORKDIR 3proxy-0.8.12
RUN head -n 28 src/proxy.h > src/_proxy.h && echo "#define ANONYMOUS 1" >> src/_proxy.h && tail -n +29 src/proxy.h >> src/_proxy.h && mv src/_proxy.h src/proxy.h
RUN make -f Makefile.Linux && make -f Makefile.Linux install
RUN mkdir -p /home/joke/proxy/logs
WORKDIR /home/joke/proxy/
WORKDIR cat > 3proxy.conf
ENTRYPOINT 3proxy /home/joke/proxy/3proxy.conf
