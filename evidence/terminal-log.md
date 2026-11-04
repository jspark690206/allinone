# 실제 실행 로그

```text
$ docker --version
Docker version 29.9.2, build a82e528
exit=0

$ docker info --format "Server={{.ServerVersion}} OS={{.OperatingSystem}}"
Server=29.9.2 OS=Docker Desktop
exit=0

$ git --version
git version 2.52.0.windows.1
exit=0

$ docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:c567b231f65614688711a75f31518a064258a51d442117a3e771a3a8fdba78ef
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
exit=0

$ docker run --name e1-cli -d ubuntu:24.04 sleep infinity
Unable to find image 'ubuntu:24.04' locally
24.04: Pulling from library/ubuntu
7a48b8f0e5c7: Pulling fs layer
98144013299c: Download complete
7a48b8f0e5c7: Download complete
7a48b8f0e5c7: Pull complete
Digest: sha256:fe81560990fae86dc4743202b2cb4d3df98d0bcf949173cecef15ce1127ef852
Status: Downloaded newer image for ubuntu:24.04
0c893875ac30a5c848495b3ffe18a2785e12d8d1a83e722a44678388a2717cf0
exit=0

$ docker exec e1-cli bash -lc "set -eu
pwd
mkdir -p /tmp/e1-lab/work
cd /tmp/e1-lab
ls -la
touch empty.txt
echo workstation > note.txt
cat note.txt
cp note.txt copy.txt
mv copy.txt renamed.txt
ls -la
rm renamed.txt
mkdir permissions
chmod 600 note.txt
chmod 700 permissions
ls -ld note.txt permissions
chmod 644 note.txt
chmod 755 permissions
ls -ld note.txt permissions
ls /tmp/e1-lab
echo inside-ubuntu
"
/
total 12
drwxr-xr-x 3 root root 4096 Nov  4 07:28 .
drwxrwxrwt 1 root root 4096 Nov  4 07:28 ..
drwxr-xr-x 2 root root 4096 Nov  4 07:28 work
workstation
total 20
drwxr-xr-x 3 root root 4096 Nov  4 07:28 .
drwxrwxrwt 1 root root 4096 Nov  4 07:28 ..
-rw-r--r-- 1 root root    0 Nov  4 07:28 empty.txt
-rw-r--r-- 1 root root   12 Nov  4 07:28 note.txt
-rw-r--r-- 1 root root   12 Nov  4 07:28 renamed.txt
drwxr-xr-x 2 root root 4096 Nov  4 07:28 work
-rw------- 1 root root   12 Nov  4 07:28 note.txt
drwx------ 2 root root 4096 Nov  4 07:28 permissions
-rw-r--r-- 1 root root   12 Nov  4 07:28 note.txt
drwxr-xr-x 2 root root 4096 Nov  4 07:28 permissions
empty.txt
note.txt
permissions
work
inside-ubuntu
exit=0

$ docker exec e1-cli bash -lc "exit 0"

exit=0

$ docker ps --filter name=e1-cli
CONTAINER ID   IMAGE          COMMAND            CREATED        STATUS                  PORTS     NAMES
0c893875ac30   ubuntu:24.04   "sleep infinity"   1 second ago   Up Less than a second             e1-cli
exit=0

$ docker stop e1-cli
e1-cli
exit=0

$ docker ps -a --filter name=e1-cli
CONTAINER ID   IMAGE          COMMAND            CREATED         STATUS                                PORTS     NAMES
0c893875ac30   ubuntu:24.04   "sleep infinity"   5 seconds ago   Exited (137) Less than a second ago             e1-cli
exit=0

$ docker build -t e1-workstation:1.0 .
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 30B
#1 transferring dockerfile: 181B 0.0s done
#1 DONE 0.2s

#2 [internal] load metadata for docker.io/library/nginx:alpine
#2 DONE 3.8s

#3 [internal] load .dockerignore
#3 transferring context:
#3 transferring context: 67B 0.0s done
#3 DONE 0.2s

#4 [internal] load build context
#4 DONE 0.0s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 ...

#4 [internal] load build context
#4 transferring context: 252B 0.0s done
#4 DONE 0.3s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.2s done
#5 DONE 1.1s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 0B / 20.53MB 0.2s
#5 sha256:9b0f7dfe35b2711a17f60dadd6d4035dc0cdee152538cc5c0987029e94679548 0B / 1.40kB 0.2s
#5 sha256:2ec5fb117ffa9a78b15fb6a78745ffc569c8da0aee9f36ace4cd67a44b1fef79 0B / 1.21kB 0.2s
#5 sha256:26185d08a3ec318dd85a6c9f2172e714ec13cececd7f33c533b40b1689f9fedb 0B / 404B 0.2s
#5 sha256:9b0f7dfe35b2711a17f60dadd6d4035dc0cdee152538cc5c0987029e94679548 1.40kB / 1.40kB 1.0s done
#5 sha256:26185d08a3ec318dd85a6c9f2172e714ec13cececd7f33c533b40b1689f9fedb 404B / 404B 1.0s done
#5 sha256:2ec5fb117ffa9a78b15fb6a78745ffc569c8da0aee9f36ace4cd67a44b1fef79 1.21kB / 1.21kB 1.2s done
#5 sha256:7cc330898115ce55acccb0cc1e7dd091df4410c8c5f3c540710ee0ac689f5fcb 0B / 964B 0.2s
#5 sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 0B / 629B 0.2s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 1.05MB / 20.53MB 1.4s
#5 sha256:7cc330898115ce55acccb0cc1e7dd091df4410c8c5f3c540710ee0ac689f5fcb 964B / 964B 0.5s done
#5 sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 629B / 629B 0.5s
#5 sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 0B / 1.94MB 0.2s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 3.15MB / 20.53MB 1.8s
#5 sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 629B / 629B 0.5s done
#5 sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 0B / 3.85MB 0.2s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 4.19MB / 20.53MB 2.1s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 5.24MB / 20.53MB 2.4s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 6.29MB / 20.53MB 2.7s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 7.34MB / 20.53MB 3.0s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 8.39MB / 20.53MB 3.3s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 9.44MB / 20.53MB 3.6s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 10.49MB / 20.53MB 3.9s
#5 sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 1.05MB / 3.85MB 2.3s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 11.53MB / 20.53MB 4.4s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 12.58MB / 20.53MB 4.5s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 13.63MB / 20.53MB 4.8s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 14.68MB / 20.53MB 5.0s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 15.73MB / 20.53MB 5.1s
#5 sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 2.10MB / 3.85MB 3.3s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 16.78MB / 20.53MB 5.3s
#5 sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 1.05MB / 1.94MB 3.8s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 17.83MB / 20.53MB 5.6s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 18.87MB / 20.53MB 5.7s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 20.53MB / 20.53MB 5.9s
#5 sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 20.53MB / 20.53MB 5.9s done
#5 sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 3.15MB / 3.85MB 4.2s
#5 sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 3.85MB / 3.85MB 4.7s
#5 sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 3.85MB / 3.85MB 4.7s done
#5 extracting sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788
#5 sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 1.94MB / 1.94MB 5.4s done
#5 extracting sha256:7b229517ed222597277036d94892173207d01a731ab3a88eeb1de2e963a2c788 0.2s done
#5 extracting sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6
#5 extracting sha256:12b85cff06fd7d383d36a9c96503fe049c9d4bf3dfda5cbb9ffa6ae99b9c07a6 0.2s done
#5 DONE 8.2s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 extracting sha256:657023555a2a19dc6036468198bb350d2c7feaac7f2d0a3901b4dd3cb25e40c5 0.1s done
#5 extracting sha256:7cc330898115ce55acccb0cc1e7dd091df4410c8c5f3c540710ee0ac689f5fcb 0.1s done
#5 DONE 8.4s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 extracting sha256:26185d08a3ec318dd85a6c9f2172e714ec13cececd7f33c533b40b1689f9fedb 0.1s done
#5 extracting sha256:2ec5fb117ffa9a78b15fb6a78745ffc569c8da0aee9f36ace4cd67a44b1fef79 0.1s done
#5 DONE 8.5s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 extracting sha256:9b0f7dfe35b2711a17f60dadd6d4035dc0cdee152538cc5c0987029e94679548 0.1s done
#5 DONE 8.6s

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#5 extracting sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919
#5 extracting sha256:b9b388a21ecfde6ac80505f23f527146a2129dfb104e79b029bbd00d4cc1a919 0.6s done
#5 DONE 9.3s

#6 [2/2] COPY site/ /usr/share/nginx/html/
#6 DONE 0.3s

#7 exporting to image
#7 exporting layers
#7 exporting layers 0.6s done
#7 exporting manifest sha256:e5845f446ead52ea92e405196ab8255cee0729ad98cf5268caf0d90e3e8b0adf
#7 exporting manifest sha256:e5845f446ead52ea92e405196ab8255cee0729ad98cf5268caf0d90e3e8b0adf 0.6s done
#7 exporting config sha256:e1ac5f550fe6daa749fcd8ee69122c98af5fb1e5b348ec6dd85d3a7529ce35bf
#7 exporting config sha256:e1ac5f550fe6daa749fcd8ee69122c98af5fb1e5b348ec6dd85d3a7529ce35bf 0.1s done
#7 exporting attestation manifest sha256:e521eb006a1432a90b69b75a3df2cdc57228ea5641042b4db6a14dbb6da76d76
#7 exporting attestation manifest sha256:e521eb006a1432a90b69b75a3df2cdc57228ea5641042b4db6a14dbb6da76d76 0.2s done
#7 exporting manifest list sha256:b52d639705a0a06a35df0cefccb8103c8d3e5e2314dacf66cfd1159d961b48b6
#7 exporting manifest list sha256:b52d639705a0a06a35df0cefccb8103c8d3e5e2314dacf66cfd1159d961b48b6 0.2s done
#7 naming to docker.io/library/e1-workstation:1.0
#7 naming to docker.io/library/e1-workstation:1.0 0.0s done
#7 unpacking to docker.io/library/e1-workstation:1.0
#7 unpacking to docker.io/library/e1-workstation:1.0 1.6s done
#7 DONE 3.4s
exit=0

$ docker run -d --name e1-web-a -p 127.0.0.1:18080:80 e1-workstation:1.0
100ab15c0a372991fae0f0ef51387f1634f846d286e79f66135c94557909b978
exit=0

$ curl.exe --fail -i http://localhost:18080
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    757      0 --:--:-- --:--:-- --:--:--   775
HTTP/1.1 200 OK
Server: nginx/1.31.8
Date: Wed, 04 Nov 2026 07:29:10 GMT
Content-Type: text/html
Content-Length: 180
Last-Modified: Wed, 04 Nov 2026 07:27:22 GMT
Connection: keep-alive
ETag: "6aeade5a-b4"
Accept-Ranges: bytes

<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 1 - reproducible workstation</p></body></html>
exit=0

$ docker run -d --name e1-web-b -p 127.0.0.1:18081:80 e1-workstation:1.0
551ea5364618904a23250097f845dd71e3fcb516ed561142ee9b79bfe5306794
exit=0

$ curl.exe --fail -i http://localhost:18081
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    851      0 --:--:-- --:--:-- --:--:--   853
HTTP/1.1 200 OK
Server: nginx/1.31.8
Date: Wed, 04 Nov 2026 07:29:13 GMT
Content-Type: text/html
Content-Length: 180
Last-Modified: Wed, 04 Nov 2026 07:27:22 GMT
Connection: keep-alive
ETag: "6aeade5a-b4"
Accept-Ranges: bytes

<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 1 - reproducible workstation</p></body></html>
exit=0

$ docker images e1-workstation
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
e1-workstation:1.0   b52d639705a0       93.6MB         26.3MB   U
exit=0

$ docker logs e1-web-a
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/11/04 07:29:09 [notice] 1#1: using the "epoll" event method
2026/11/04 07:29:09 [notice] 1#1: nginx/1.31.8
2026/11/04 07:29:09 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/11/04 07:29:09 [notice] 1#1: OS: Linux 7.0.14-linuxkit
2026/11/04 07:29:09 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/11/04 07:29:09 [notice] 1#1: start worker processes
2026/11/04 07:29:09 [notice] 1#1: start worker process 30
2026/11/04 07:29:09 [notice] 1#1: start worker process 31
2026/11/04 07:29:09 [notice] 1#1: start worker process 32
2026/11/04 07:29:09 [notice] 1#1: start worker process 33
2026/11/04 07:29:09 [notice] 1#1: start worker process 34
2026/11/04 07:29:09 [notice] 1#1: start worker process 35
2026/11/04 07:29:09 [notice] 1#1: start worker process 36
2026/11/04 07:29:09 [notice] 1#1: start worker process 37
172.17.0.1 - - [04/Nov/2026:07:29:10 +0000] "GET / HTTP/1.1" 200 180 "-" "curl/8.13.0" "-"
exit=0

$ docker stats --no-stream e1-web-a
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O     PIDS
100ab15c0a37   e1-web-a   0.00%     8.574MiB / 1.916GiB   0.44%     1.93kB / 923B   0B / 12.3kB   9
exit=0

$ docker run -d --name e1-bind -p 127.0.0.1:18083:80 --mount type=bind,source=D:\!!!Codyssay자료\mission_work\workstation-e1\site,target=/usr/share/nginx/html,readonly e1-workstation:1.0
01b78bfb86e6c489378315dea8b3c51732b2fa4f04ff1001f191ad0bc64da25e
exit=0

$ curl.exe --fail http://localhost:18083
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    841      0 --:--:-- --:--:-- --:--:--   845
<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 1 - reproducible workstation</p></body></html>
exit=0

$ Host file edit: site/index.html Release 1 -> Release 2
Saved UTF-8 content
exit=0

$ curl.exe --fail http://localhost:18083
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    825      0 --:--:-- --:--:-- --:--:--   829
<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 2 - reproducible workstation</p></body></html>
exit=0

$ docker volume create e1-persistent
e1-persistent
exit=0

$ docker run --name e1-vol-before -v e1-persistent:/data ubuntu:24.04 bash -lc "echo e1-data-survives > /data/proof.txt; cat /data/proof.txt"
e1-data-survives
exit=0

$ docker rm e1-vol-before
e1-vol-before
exit=0

$ docker run --name e1-vol-after -v e1-persistent:/data ubuntu:24.04 cat /data/proof.txt
e1-data-survives
exit=0

$ docker compose version
Docker Compose version v5.6.1
exit=0

$ docker compose -p e1bonus config
name: e1bonus
services:
  web:
    restart: unless-stopped
    image: e1-workstation:1.0
    networks:
      default: null
    volumes:
      - type: bind
        source: D:\!!!Codyssay자료\mission_work\workstation-e1\site
        target: /usr/share/nginx/html
        read_only: true
        bind: {}
    build:
      context: D:\!!!Codyssay자료\mission_work\workstation-e1
      dockerfile: Dockerfile
    ports:
      - mode: ingress
        host_ip: 127.0.0.1
        target: 80
        published: "18082"
        protocol: tcp
networks:
  default:
    name: e1bonus_default
exit=0

$ docker compose -p e1bonus up -d --build
Image e1-workstation:1.0 Building 
#1 [internal] load local bake definitions
#1 reading from stdin 550B 0.1s done
#1 DONE 0.1s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 181B done
#2 DONE 0.1s

#3 [internal] load metadata for docker.io/library/nginx:alpine
#3 DONE 0.6s

#4 [internal] load .dockerignore
#4 transferring context: 67B done
#4 DONE 0.1s

#5 [internal] load build context
#5 transferring context: 252B done
#5 DONE 0.1s

#6 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#6 resolve docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606 0.1s done
#6 DONE 0.2s

#6 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2aed0606
#6 CACHED

#7 [2/2] COPY site/ /usr/share/nginx/html/
#7 DONE 0.2s

#8 exporting to image
#8 exporting layers
#8 exporting layers 0.6s done
#8 exporting manifest sha256:9dbbc62be4322c4b83482bb6782f61140d9e4cb18e7351cf76a51a87967bf9cf 0.1s done
#8 exporting config sha256:846d745051a656eb982a48dcab76241adbd3b3a8fc818a9eb65d8737f098a26f 0.1s done
#8 exporting attestation manifest sha256:23aa3bcdde19afa4083c698a98a4dcd21c63d3603565845f6e2072eb3ce70102 0.1s done
#8 exporting manifest list sha256:937fbf4ddf693292292ad9cc478a2d61ea6adf64c4c316ed2b91935afda98307
#8 exporting manifest list sha256:937fbf4ddf693292292ad9cc478a2d61ea6adf64c4c316ed2b91935afda98307 0.1s done
#8 naming to docker.io/library/e1-workstation:1.0 0.0s done
#8 unpacking to docker.io/library/e1-workstation:1.0 0.1s done
#8 DONE 1.2s

#9 resolving provenance for metadata file
#9 DONE 0.0s
 Image e1-workstation:1.0 Built 
 Network e1bonus_default Creating 
 Network e1bonus_default Creating 
 Network e1bonus_default Created 
 Network e1bonus_default Created 
 Container e1bonus-web-1 Creating 
 Container e1bonus-web-1 Created 
 Container e1bonus-web-1 Starting 
 Container e1bonus-web-1 Started
exit=0

$ docker compose -p e1bonus ps
NAME            IMAGE                COMMAND                  SERVICE   CREATED         STATUS        PORTS
e1bonus-web-1   e1-workstation:1.0   "/docker-entrypoint.…"   web       2 seconds ago   Up 1 second   127.0.0.1:18082->80/tcp
exit=0

$ curl.exe --fail -i http://localhost:18082
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    855      0 --:--:-- --:--:-- --:--:--   857
HTTP/1.1 200 OK
Server: nginx/1.31.8
Date: Wed, 04 Nov 2026 07:29:30 GMT
Content-Type: text/html
Content-Length: 180
Last-Modified: Wed, 04 Nov 2026 07:29:21 GMT
Connection: keep-alive
ETag: "6aeaded1-b4"
Accept-Ranges: bytes

<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 2 - reproducible workstation</p></body></html>
exit=0

$ docker compose -p e1bonus logs --tail 8
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 31
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 32
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 33
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 34
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 35
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 36
web-1  | 2026/11/04 07:29:28 [notice] 1#1: start worker process 37
web-1  | 172.18.0.1 - - [04/Nov/2026:07:29:30 +0000] "GET / HTTP/1.1" 200 180 "-" "curl/8.13.0" "-"
exit=0

$ docker compose -p e1bonus down
Container e1bonus-web-1 Stopping 
 Container e1bonus-web-1 Stopped 
 Container e1bonus-web-1 Removing 
 Container e1bonus-web-1 Removed 
 Network e1bonus_default Removing 
 Network e1bonus_default Removed
exit=0

$ git init -b main
Initialized empty Git repository in D:/!!!Codyssay자료/mission_work/workstation-e1/.git/
exit=0

$ git config user.name "E1 Learner"
fatal: not in a git directory
exit=128

$ git config user.email learner@example.invalid
fatal: not in a git directory
exit=128

$ git config init.defaultBranch main
fatal: not in a git directory
exit=128

$ git config --local --list
fatal: --local can only be used inside a git repository
exit=128

$ docker rm -f e1-web-a
e1-web-a
exit=0

$ docker rm -f e1-web-b
e1-web-b
exit=0

$ docker rm -f e1-bind
e1-bind
exit=0

$ docker rm -f e1-cli
e1-cli
exit=0

$ docker rm -f e1-vol-after
e1-vol-after
exit=0
```
