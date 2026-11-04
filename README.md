# allinone
코디세이1-1 프로젝트

# 개발 워크스테이션 구축 실습

[전체 실행 명령과 출력](evidence/terminal-log.md) | [구조화 로그](evidence/logs.json)

미션 E1 1 | Linux CLI Docker Git GitHub | 2026년 11월 4일

NGINX 커스텀 이미지를 직접 작성한 Dockerfile로 빌드하고, 서로 다른 호스트 포트의 접속, 바인드 마운트 변경 반영, 컨테이너 삭제 뒤 볼륨 데이터 유지까지 검증했다. Windows에서는 PowerShell을, Linux 명령과 권한 실습에는 Ubuntu 컨테이너의 bash를 사용했다.

## 1 결과 예시 분석과 구현 원칙

원문 6~7쪽은 제출 형식과 검증 흐름을 보여 주는 참고 예시다. 폴더명과 로그를 복사하지 않고 e1-workstation 이미지, 18080과 18081 포트, e1-data-survives 데이터로 실제 수행 결과를 구성했다.

예시의 NGINX 기본 이미지와 8080:5000 매핑은 그대로 결합하면 맞지 않는다. 이 구현은 NGINX가 실제 수신하는 80번 포트를 대상으로 18080:80과 18081:80을 설정했다. EXPOSE는 포트 게시를 대신하지 않으므로 docker run에서 직접 매핑했다.

## 2 실행 환경과 제출 구성

```text
$ docker --version
Docker version 29.9.2, build a82e528
exit=0
```

```text
$ docker info --format "Server={{.ServerVersion}} OS={{.OperatingSystem}}"
Server=29.9.2 OS=Docker Desktop
exit=0
```

```text
$ git --version
git version 2.52.0.windows.1
exit=0
```

호스트는 Windows, 실행 셸은 PowerShell, 터미널은 Codex 명령 실행 환경이다. Linux 실습은 ubuntu:24.04의 bash에서 진행했다. Docker Desktop 엔진을 사용했으므로 macOS 전용 OrbStack은 적용하지 않았다. sudo 없이 이미 구동된 엔진을 사용했다.

제출 저장소 https://github.com/jspark690206/allinone
구성 README.md, Dockerfile, site/index.html, docker-compose.yml, evidence/terminal-log.md, evidence/logs.json. 모든 상세 명령과 출력은 README에서 상대 링크로 연결한다.

## 3 요구 사항 점검

완료  터미널 이동 생성 복사 이름변경 삭제 내용 확인 빈 파일 생성

완료  파일 및 디렉토리 권한 변경 전후 확인

완료  Docker 버전 데몬 이미지 실행 중지 목록 로그 리소스 확인

완료  hello-world Ubuntu 컨테이너 exec 종료와 주 프로세스 중지 비교

완료  직접 작성한 Dockerfile 빌드 및 두 포트 HTTP 접속

완료  바인드 마운트 전후 비교와 볼륨 삭제 전후 데이터 비교

완료  로컬 Git 사용자 정보 및 main 브랜치 설정

확인 필요  VSCode GitHub 로그인 화면과 주소창이 포함된 브라우저 캡처

## 4 터미널 조작과 Linux 권한 실습

컨테이너 안에서 /tmp/e1-lab를 실습 경로로 만들었다. 절대 경로 /tmp/e1-lab/note.txt는 현재 위치와 관계없이 같은 파일을 가리킨다. 상대 경로 note.txt는 현재 위치가 /tmp/e1-lab일 때 같은 파일을 가리킨다. cd work 뒤에는 ../note.txt로 상위 폴더의 파일에 접근한다.

```text
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
```

권한은 소유자 그룹 기타 사용자 순서다. r=4, w=2, x=1을 합산한다. 파일 644는 소유자 읽기와 쓰기, 나머지는 읽기다. 디렉토리 755는 소유자 rwx, 나머지 r-x다. 파일 x는 실행, 디렉토리 x는 경로 통과를 뜻한다. 디렉토리 항목 삭제에는 일반적으로 부모 디렉토리의 w와 x가 필요하다.

이번 chmod 결과는 Linux 컨테이너 내부 파일시스템에서 확인했다. Windows NTFS의 ACL을 Linux 권한 숫자와 동일하게 해석하지 않는다.

## 5 Docker 기본 운영과 컨테이너 수명

```text
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

To generate this message, Docke
[중간 생략 전체 로그 참조]
ntainer from that image which runs the
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
```

```text
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
```

```text
$ docker exec e1-cli bash -lc "exit 0"

exit=0
```

```text
$ docker ps --filter name=e1-cli
CONTAINER ID   IMAGE          COMMAND            CREATED        STATUS                  PORTS     NAMES
0c893875ac30   ubuntu:24.04   "sleep infinity"   1 second ago   Up Less than a second             e1-cli
exit=0
```

```text
$ docker stop e1-cli
e1-cli
exit=0
```

```text
$ docker ps -a --filter name=e1-cli
CONTAINER ID   IMAGE          COMMAND            CREATED         STATUS                                PORTS     NAMES
0c893875ac30   ubuntu:24.04   "sleep infinity"   5 seconds ago   Exited (137) Less than a second ago             e1-cli
exit=0
```

exec로 실행한 bash가 exit 0으로 끝나도 주 프로세스 sleep infinity는 계속 실행되었다. docker stop은 주 프로세스를 중지해 컨테이너 상태를 Exited로 바꾸었다. attach는 기존 주 프로세스 입출력에 연결하고, exec는 별도 프로세스를 실행한다. 이 실습은 exec와 stop을 실제 비교했으며 attach를 직접 실행한 로그는 포함하지 않는다.

## 6 Dockerfile 기반 웹 서버 최종 결과

기존 베이스는 nginx:alpine이다. LABEL은 이미지 용도 식별, COPY는 기본 환영 페이지를 과제 사이트로 교체하는 역할이다. ENV APP_ENV는 학습용 메타 설정으로 두었으며 NGINX 수신 포트를 변경하지 않는다. 소스 변경을 이미지에 담으려면 다시 빌드해야 한다.

```text
FROM nginx:alpine
LABEL org.opencontainers.image.title="e1-workstation"
ENV APP_ENV=learning
COPY site/ /usr/share/nginx/html/
EXPOSE 80

```

### 웹 페이지 소스

```text
<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 2 - reproducible workstation</p></body></html>
```

웹 소스 최종본은 마운트 검증 후 Release 2이다. 초기 이미지에는 빌드 당시 Release 1이 들어 있다. 동일 태그의 베이스 이미지가 장기적으로 바뀔 수 있으므로 엄격한 재현이 필요하면 사용 이미지의 digest를 고정하고 갱신을 관리한다.

```text
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

#5 [1/2] FROM docker.io/library/nginx:alpine@sha256:785835ea65db4bba6f021acc0f3be91b0fef76a53fe41f8588c6698d2ae
[중간 생략 전체 로그 참조]
 attestation manifest sha256:e521eb006a1432a90b69b75a3df2cdc57228ea5641042b4db6a14dbb6da76d76 0.2s done
#7 exporting manifest list sha256:b52d639705a0a06a35df0cefccb8103c8d3e5e2314dacf66cfd1159d961b48b6
#7 exporting manifest list sha256:b52d639705a0a06a35df0cefccb8103c8d3e5e2314dacf66cfd1159d961b48b6 0.2s done
#7 naming to docker.io/library/e1-workstation:1.0
#7 naming to docker.io/library/e1-workstation:1.0 0.0s done
#7 unpacking to docker.io/library/e1-workstation:1.0
#7 unpacking to docker.io/library/e1-workstation:1.0 1.6s done
#7 DONE 3.4s
exit=0
```

```text
$ docker run -d --name e1-web-a -p 127.0.0.1:18080:80 e1-workstation:1.0
100ab15c0a372991fae0f0ef51387f1634f846d286e79f66135c94557909b978
exit=0
```

```text
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
```

```text
$ docker run -d --name e1-web-b -p 127.0.0.1:18081:80 e1-workstation:1.0
551ea5364618904a23250097f845dd71e3fcb516ed561142ee9b79bfe5306794
exit=0
```

```text
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
```

두 주소의 HTTP 200 응답과 E1 Developer Workshop 본문이 접속 성공 근거다. 127.0.0.1로 게시하여 같은 PC에서만 접속하도록 했다. curl 증거는 기능 요구 사항의 대체 증거를 충족하지만, 최종 결과물 항목의 주소창 포함 브라우저 캡처는 별도 추가해야 한다.

## 7 이미지 로그와 리소스 확인

```text
$ docker images e1-workstation
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
e1-workstation:1.0   b52d639705a0       93.6MB         26.3MB   U
exit=0
```

```text
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
```

```text
$ docker stats --no-stream e1-web-a
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O     PIDS
100ab15c0a37   e1-web-a   0.00%     8.574MiB / 1.916GiB   0.44%     1.93kB / 923B   0B / 12.3kB   9
exit=0
```

이미지는 실행 환경의 템플릿이고 컨테이너는 그 이미지로 만든 실행 인스턴스다. 같은 이미지에서 두 컨테이너를 만들고 각각 다른 호스트 포트를 게시했다. logs는 표준 출력과 오류 기록, stats --no-stream은 한 시점의 CPU와 메모리 사용량을 보여 준다.

## 8 바인드 마운트 변경 반영

```text
$ docker run -d --name e1-bind -p 127.0.0.1:18083:80 --mount type=bind,source=D:\!!!Codyssay자료\mission_work\workstation-e1\site,target=/usr/share/nginx/html,readonly e1-workstation:1.0
01b78bfb86e6c489378315dea8b3c51732b2fa4f04ff1001f191ad0bc64da25e
exit=0
```

```text
$ curl.exe --fail http://localhost:18083
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    841      0 --:--:-- --:--:-- --:--:--   845
<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 1 - reproducible workstation</p></body></html>
exit=0
```

```text
$ Host file edit: site/index.html Release 1 -> Release 2
Saved UTF-8 content
exit=0
```

```text
$ curl.exe --fail http://localhost:18083
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100   180  100   180    0     0    825      0 --:--:-- --:--:-- --:--:--   829
<!doctype html><html lang="ko"><meta charset="utf-8"><title>E1 개발 작업실</title><body><h1>E1 Developer Workshop</h1><p>Release 2 - reproducible workstation</p></body></html>
exit=0
```

호스트 site 폴더를 컨테이너의 정적 콘텐츠 경로에 읽기 전용으로 연결했다. 호스트 파일을 Release 1에서 Release 2로 바꾼 뒤 같은 컨테이너에서 새 응답을 확인했다. readonly는 컨테이너의 쓰기를 막으며 호스트 편집은 허용한다. 마운트는 이미지 안의 같은 경로를 가리므로 이미지 내용 자체가 수정된 것은 아니다.

재현할 때는 프로젝트 루트에서 PowerShell의 $site = (Resolve-Path ./site).Path로 절대 경로를 구한 뒤 --mount "type=bind,source=$site,target=/usr/share/nginx/html,readonly"를 사용한다. 경로에 공백이 있으면 인수 전체를 따옴표로 묶는다.

## 9 Docker 볼륨 영속성 검증

```text
$ docker volume create e1-persistent
e1-persistent
exit=0
```

```text
$ docker run --name e1-vol-before -v e1-persistent:/data ubuntu:24.04 bash -lc "echo e1-data-survives > /data/proof.txt; cat /data/proof.txt"
e1-data-survives
exit=0
```

```text
$ docker rm e1-vol-before
e1-vol-before
exit=0
```

```text
$ docker run --name e1-vol-after -v e1-persistent:/data ubuntu:24.04 cat /data/proof.txt
e1-data-survives
exit=0
```

e1-vol-before가 볼륨에 proof.txt를 썼고, 그 컨테이너를 삭제한 후 e1-vol-after가 같은 e1-persistent 볼륨에서 e1-data-survives를 읽었다. 따라서 컨테이너 삭제와 데이터 삭제는 분리된다. 실습 후 컨테이너는 정리했으며 증거 데이터를 담은 볼륨은 남겨 두었다. docker volume rm e1-persistent는 데이터가 필요 없을 때만 실행한다.

## 10 Git 설정과 GitHub 제출

```text
$ git -c safe.directory=D:/!!!Codyssay자료/mission_work/workstation-e1 config --local --list
core.repositoryformatversion=0
core.filemode=false
core.bare=false
core.logallrefupdates=true
core.symlinks=false
core.ignorecase=true
user.name=E1 Learner
user.email=learner@example.invalid
init.defaultbranch=main
remote.origin.url=https://github.com/jspark690206/allinone.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*

```

```text
$ git -c safe.directory=D:/!!!Codyssay자료/mission_work/workstation-e1 remote -v
origin	https://github.com/jspark690206/allinone.git (fetch)
origin	https://github.com/jspark690206/allinone.git (push)

```

Git은 로컬 변경과 커밋 이력을 관리한다. GitHub는 원격 저장소와 협업 기능을 제공한다. 과제 저장소에만 user.name, user.email, init.defaultBranch를 설정했으며 전역 설정은 변경하지 않았다. learner@example.invalid는 개인 메일을 노출하지 않는 실습용 작성자 주소다.

VSCode에서 이 폴더를 열고 Accounts에서 GitHub에 로그인한 뒤 Source Control의 원격 저장소 연결을 확인한다. 로그인 화면이나 원격 연결 화면에는 토큰과 인증 코드를 담지 않는다. GitHub 업로드만으로 VSCode 로그인까지 입증되지는 않는다.

## 11 트러블슈팅과 재현 절차

### Docker 엔진 접근 거부

문제: 초기 docker info에서 config.json 접근 거부와 npipe Docker API permission denied가 발생했다. 원인 가설: Docker 미설치가 아니라 실행 환경의 접근 권한 제한이다. 확인: docker --version은 29.9.2를 반환했고 승인된 실행 환경에서 docker info가 Server=29.9.2를 반환했다. 해결: 승인된 실행 컨텍스트로 Docker 실습을 수행했다. 무조건 관리자 권한이나 재설치로 해결한다고 일반화하지 않는다.

### Git 로컬 설정 실패

문제: Docker 실습과 같은 실행 컨텍스트에서 git config가 fatal: not in a git directory로 실패했다. 원인 가설: 실행 사용자 또는 저장소 접근 컨텍스트 차이다. 확인: 일반 작업 환경에서 git status가 main 브랜치와 추적 전 파일을 정상 표시했고 같은 폴더에서 git config --local --list가 성공했다. 해결: Git 작업을 일반 작업 환경에서 수행했다. 전체 오류와 후속 성공 결과를 증거 로그에 구분해 보존한다.

### 다른 PC에서 재현

```text
git clone https://github.com/jspark690206/allinone.git
cd allinone
docker info
docker build -t e1-workstation:1.0 .
docker run -d --name e1-review -p 127.0.0.1:18080:80 e1-workstation:1.0
curl.exe --fail -i http://localhost:18080
docker rm -f e1-review
docker compose -p e1bonus up -d --build
curl.exe --fail -i http://localhost:18082
docker compose -p e1bonus down
```

Windows PowerShell에서는 curl.exe를 사용한다. Linux와 macOS에서는 curl로 바꾼다. 포트 사용 중 오류가 나면 호스트 포트만 비어 있는 번호로 바꾸고 접속 URL도 함께 바꾼다. Linux 권한 실습은 Ubuntu 컨테이너 안에서 수행한다. 민감한 파일과 토큰은 저장소에 넣지 않는다.

기본 미션 최종 결과물 끝. 다음 내용은 선택한 보너스 과제의 수행 결과와 상세 설명이다.

## 12 보너스 과제 Docker Compose 기초

선택 과제는 5개 중 1번이다. 웹 서버 한 개를 Compose로 실행해 개별 docker run 인수가 저장 가능한 실행 설정으로 바뀌는 과정을 확인했다. 멀티 컨테이너나 SSH 설정은 선택 범위에 포함하지 않는다.

### 실제 작성한 설정

```text
services:
  web:
    build: .
    image: e1-workstation:1.0
    ports:
      - "127.0.0.1:18082:80"
    volumes:
      - ./site:/usr/share/nginx/html:ro
    restart: unless-stopped

```

services 아래 web은 서비스 이름이다. build: .은 현재 폴더 Dockerfile로 빌드한다. image는 생성 이미지 태그다. ports의 127.0.0.1:18082:80은 로컬 PC 18082 요청을 컨테이너 80으로 전달한다. volumes는 프로젝트의 site 폴더를 NGINX 콘텐츠 경로에 읽기 전용으로 연결한다. restart: unless-stopped는 중지 의도를 유지하면서 재시작 정책을 설정한다. 이 정책이 이번 실습에서 장애 복구 시험을 수행했다는 뜻은 아니다.

Compose 파일은 실행 명령을 YAML로 기록한다. 팀원은 포트와 마운트 옵션을 기억해 다시 입력하는 대신 같은 파일로 up을 실행한다. 파일을 Git으로 관리하면 실행 설정 변경도 리뷰할 수 있다. 상대 경로 ./site는 Compose 프로젝트 위치를 기준으로 해석되므로 개인 PC 절대 경로 의존을 줄인다.

### 단계별 검증

```text
$ docker compose version
Docker Compose version v5.6.1
exit=0
```

```text
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
#6 resolve docker.io/library/nginx:alpine@sha256:785835ea65db
[중간 생략 전체 로그 참조]
c478a2d61ea6adf64c4c316ed2b91935afda98307
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
```

```text
$ docker compose -p e1bonus ps
NAME            IMAGE                COMMAND                  SERVICE   CREATED         STATUS        PORTS
e1bonus-web-1   e1-workstation:1.0   "/docker-entrypoint.…"   web       2 seconds ago   Up 1 second   127.0.0.1:18082->80/tcp
exit=0
```

```text
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
```

```text
$ docker compose -p e1bonus down
Container e1bonus-web-1 Stopping 
 Container e1bonus-web-1 Stopped 
 Container e1bonus-web-1 Removing 
 Container e1bonus-web-1 Removed 
 Network e1bonus_default Removing 
 Network e1bonus_default Removed
exit=0
```

1 config로 구문과 해석 결과를 확인했다. 2 up -d --build로 빌드 후 백그라운드 실행했다. 3 ps로 실행 상태와 포트 매핑을 확인했다. 4 curl로 HTTP 200과 Release 2 응답을 확인했다. 5 logs로 접근 기록을 확인하고 down으로 서비스 컨테이너와 네트워크를 정리했다. Compose에서 name을 직접 지정하지 않았으므로 -p e1bonus가 프로젝트 자원 이름을 구분한다.

### 이미지 콘텐츠와 마운트 콘텐츠의 차이

이 설정은 개발 편의를 위해 바인드 마운트를 사용한다. site 변경은 이미지 재빌드 없이 응답에 반영된다. 마운트를 제거하면 컨테이너는 이미지의 COPY 결과를 사용하므로 수정 후 다시 빌드해야 한다. 배포 시에는 개발 PC 경로에 의존하지 않도록 마운트 없이 이미지에 콘텐츠를 포함하는 구성을 선택할 수 있다.

### 완료 판단 기준

Compose 서비스가 Up 상태이고 localhost:18082에서 HTTP 200을 반환하며 페이지 본문이 Release 2이면 실행 검증을 통과한다. down 뒤에는 서비스 컨테이너가 정리되어야 한다. 이 실습의 Compose 서비스에는 named volume을 연결하지 않았으므로 기본 미션의 e1-persistent 볼륨 실험과는 별개다.

근거 문서 미션 1 E1 1 PDF의 최종 결과물 기능 요구 사항 제약 사항 결과 예시 및 보너스 과제 항목.

