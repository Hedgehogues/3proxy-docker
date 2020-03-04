# 3proxy for Debian 9

[3proxy](https://github.com/z3apa3a/3proxy) is transparent proxy

# Start with docker

You can use clearly docker:

    docker build . -t 3proxy
    docker run -p 8080:8080 3proxy
    
Or you can use docker-compose:

    docker-compose up
    
3proxy listening *8080* port. For test, you can use curl with trace:

    curl -x 0.0.0.0:8080 yandex.ru --trace curl.log

After that, you can open *curl.log* and you can see like [log](curl.log)

# Start without docker

**Notice**: If you want Ubuntu or another system, you have a problem with build

3proxy is transpanent proxy server

Befire installing, you nned update and upgrade system:

    user@debian9:~# sudo apt-get update && sudo apt-get upgrade

1. Install ifconfig (from the net-tools package)

    user@debian9:~# apt-get install net-tools

2 Activate root

    user@debian9:~# sudo su

2.1 Installing basic packages for compiling **3proxy** from source

    root@debian9:~# apt-get install build-essential libevent-dev libssl-dev -y

2.2. Create a folder to download the archive with source

    root@debian9:~# mkdir -p /opt/proxy

2.3. Let's go to this folder

    root@debian9:~# cd /opt/proxy

2.4. Now download the latest **3proxy** package. At the time of writing (see links), the latest stable version was *0.8.12 (04/18/2018)* Download it from the official **3proxy** website

    root@debian9:/opt/proxy# wget https://github.com/z3APA3A/3proxy/archive/0.8.12.tar.gz
  
4.5. Unzip the downloaded archive

    root@debian9:/opt/proxy# tar zxvf 0.8.12.tar.gz

4.6. Go to the unpacked directory to build the program

    root@debian9:/opt/proxy# cd 3proxy-0.8.12

4.7. Next, you need to add a line to the header file so that our server is completely anonymous (it really works, everything is checked, ip clients are hidden)

    root@debian9:/opt/proxy/3proxy-0.8.12# nano +29 src/proxy.h

Add a line

    #define ANONYMOUS 1

Press `Ctrl + x` and Enter to save the changes.

4.8. Let's build the program

    root@debian9:/opt/proxy/3proxy-0.8.12# make -f Makefile.Linux

Makelog

> make[2]: Leaving directory '/opt/proxy/3proxy-0.8.12/src/plugins/TransparentPlugin'

> make[1]: Leaving directory '/opt/proxy/3proxy-0.8.12/src'

No errors, continue.

4.9. Install the program in the system

    root@debian9:/opt/proxy/3proxy-0.8.12# make -f Makefile.Linux install

4.10. Go to the root directory and check where the program is installed.

    root@debian9:/opt/proxy/3proxy-0.8.12# cd ~/
    root@debian9:~# whereis 3proxy
  
> 3proxy: /usr/local/bin/3proxy /usr/local/etc/3proxy

4.11. Create a folder for configuration files and logs in the user's home directory

    root@debian9:~# mkdir -p /home/joke/proxy/logs

4.12. Go to the directory where the config should be

    root@debian9:~# cd /home/joke/proxy/

4.13. Create an empty file and copy the config there

    root@debian9:/home/joke/proxy# cat > 3proxy.conf
  
[3proxy_auth.conf](3proxy_auth.conf):
  
If you want set no auth, you need another config (`auth none`):

[3proxy.conf](3proxy.conf):

To save, press **Ctrl + Z**

4.14. Create a pid file so that there are no errors at startup.

    root@debian9:/home/joke/proxy# cat > 3proxy.pid

To save, press **Ctrl + Z**

4.15. Launch a proxy server!

    root@debian9:/home/joke/proxy# 3proxy /home/joke/proxy/3proxy.conf

4.16. Let's see if the server is listening on ports

    root@debian9:~/home/joke/proxy# netstat -nlp

`netstat log`
> Active Internet connections (only servers)
>
> Proto Recv-Q Send-Q Local Address Foreign Address State PID / Program name
>
> tcp 0 0 0.0.0.0:8080 0.0.0.0:* LISTEN 504 / 3proxy
>
> tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN 338 / sshd
>
> tcp 0 0 0.0.0.0lla128 0.0.0.0:* LISTEN 504 / 3proxy
>
> tcp6 0 0 ::: 22 ::: * LISTEN 338 / sshd
>
> udp 0 0 0.0.0.0:68 0.0.0.0:* 352 / dhclient

As it was written in the config, the web proxy listens to port **8080**, and the Socks5 proxy listens to **3128**.

4.17. To start the proxy service after rebooting, add it to CRON.

    root@debian9:/home/joke/proxy# crontab -e

Add a line

    @reboot /usr/local/bin/3proxy /home/joke/proxy/3proxy.conf

Press Enter, as CRON should see the end of line character and save the file.

There should be a message about installing a new crontab.

> crontab: installing new crontab

4.18. We will reboot the system and try to connect through the browser to the proxy. For verification, we use the Firefox browser (for web proxy) and the FoxyProxy add-on for socks5 with authentication.

    root@debian9:/home/joke/proxy# reboot

4.19. After checking the proxy after rebooting, you can see the logs. This completes the proxy setup.

> 1542573996.018 PROXY.8080 00000 tester 192.168.23.10:50915 217.12.15.54:443 1193 6939 0 CONNECT_ads.yahoo.com:443_HTTP/1.1
>
> 1542574289.634 SOCK5.3128 00000 tester 192.168.23.10:51193 54.192.13.69:443 0 0 0 CONNECT_normandy.cdn.mozilla.net:443


links: 

* https://habr.com/ru/post/460469/
* https://github.com/z3APA3A/3proxy/wiki/3proxy-%D0%B4%D0%BB%D1%8F-%D1%87%D0%B0%D0%B9%D0%BD%D0%B8%D0%BA%D0%BE%D0%B2
