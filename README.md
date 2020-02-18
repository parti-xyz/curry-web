# 빠띠 캠페인즈 Campaigns

## 실환경 구축 방법

페이스북, 트위터를 연결합니다. 각 키는 shared/config/env.yml에 등록합니다.

S3_로 시작하는 것은 아마존 s3 관련된 정보입니다.

```
production:
  ...
  FACEBOOK_APP_ID: xx
  FACEBOOK_APP_SECRET: xx
  TWITTER_APP_ID: xx
  TWITTER_APP_SECRET: xx
  S3_ACCESS_KEY: xx
  S3_SECRET_KEY: xx
  S3_REGION: xx
  S3_BUCKET: xx
  GOOGLE_API_KEY: xx
  SLACK_EXCEPTION_WEBHOOK_URL: xx
  SLACK_ARTICLE_WEBHOOK_KEY: xx
  GOOGLE_CLIENT_ID: xx
  GOOGLE_CLIENT_SECRET: xx
  DATA_GO_KR_API_KEY: xx
  PARTI_API_BASE: xx
```


## 로컬 개발 환경 구축 방법

기본적인 Rail 개발 환경에 rbenv, pow/powder를 이용합니다.

```
$ rbenv install 2.4.7
$ gem install bundler:2.0.1
$ bundle _2.0.1_ install
```
에러나면 `# gem update --system`

### 소스관리 설정

반드시 https://github.com/awslabs/git-secrets 를 설치하도록 합니다. 설치 후에 반드시 https://github.com/awslabs/git-secrets#installing-git-secrets 이 부분을 참고하여 로컬 레포지토리에 모두 설정 합니다.

```
$ git secrets --install
$ git secrets --register-aws
```

그리고 데이터베이스는 각 레포지토리마다 다릅니다. 아래 git hook 을 설정합니다

```
$ echo $'#!/bin/sh\nif [ "1" == "$3" ]; then spring stop && powder restart; fi' > .git/hooks/post-checkout
$ chmod +x .git/hooks/post-checkout
```

### 데이터베이스 준비

#### mysql 설정
mysql을 구동해야합니다. mysql의 encoding은 utf8mb4를 사용합니다. mysql은 버전 5.6 이상을 사용합니다.

encoding세팅은 my.cnf에 아래 설정을 넣고 반드시 재구동합니다. 참고로 맥에선 /usr/local/Cellar/mysql/(설치하신 mysql버전 번호)/my.cnf입니다.

```
[mysqld]
innodb_file_format=Barracuda
innodb_large_prefix = ON
```

#### 연결 정보

프로젝트 최상위 폴더에 local_env.yml이라는 파일을 만듭니다. 데이터베이스 연결 정보를 아래와 예시를 보고 적당히 입력합니다.

```
development:
  database:
    username: 사용자이름
    password: 암호
```

##### docker mysql

```
# docker pull mysql:5
# mkdir -p $HOME/docker/volumes/mysql
# docker run --rm --name mysql \
  -e MYSQL_ROOT_PASSWORD=docker \
  -e MYSQL_DATABASE=govcraft_development_master \
  -e MYSQL_USER=swain \
  -e MYSQL_PASSWORD=swain \
  -d -p 3306:3306 \
  -v $HOME/docker/volumes/mysql:/var/lib/mysql \
  mysql:5
# brew install mysql-client@5.7
# mysql -h 127.0.0.1 -P 3306 -u swain -D govcraft_development_master -p
```

gem install mysql2 에러날 시 `# gem install mysql2 -v '0.4.10' --source 'https://rubygems.org/' -- --with-opt-dir="$(brew --prefix openssl)"`


### 로그인 준비

#### puma-dev

로컬 개발 환경에 https가 되어야 로그인 테스트가 가능하다.
* 퓨마 설치 https://github.com/puma/puma-dev
* 캠페인즈 서버 띄우기  `# puma-dev link -n campaigns`

#### SNS 연동

페이스북, 트위터를 연결합니다. 각 키는 프로젝트 최상위 폴더에 .powenv에 등록합니다.

```
export FACEBOOK_APP_ID="xx"
export FACEBOOK_APP_SECRET="xx"
export TWITTER_APP_ID="xx"
export TWITTER_APP_SECRET="xx"
export GOOGLE_CLIENT_ID="xx"
export GOOGLE_CLIENT_SECRET="xx"
```

### 선거 정보

```
$ source .powenv
$ bundle exec rails db:seed_fu
```

### 국회의원 정보 data.go.kr
data.go.kr의 키를 발급받아 .powenv에 저장한다

```
export DATA_GO_KR_API_KEY=xxx
```

이후 한번만 아래 명령어를 실행한다.
```
bin/rake data:load_once_assembly_members
```

### 구글API연결

.powenv에 등록합니다.

```
export GOOGLE_API_KEY="xx"
```

### 빠띠API연결

.powenv에 등록합니다.

```
export PARTI_API_BASE="xx"
```

### 로컬에서 한글 이름의 파일을 다운로드하면 파일 이름이 깨질 때

.powenv에 아래를 추가합니다.

```
export FILENAME_ENCODING="ISO-8859-1"
```

### 사이드킥을 로컬에서 테스트하려면
.powenv에 아래를 추가합니다.

```
export SIDEKIQ=true
```

redis를 구동합니다

```
$ redis-server
```

사이드킥을 구동합니다

```
$ source .powenv && bundle exec sidekiq
```

puma를 재기동합니다

### SES 반송 테스트

ngrok 등을 이용, 로컬 웹서버를 외부에 오픈합니다.

$ ngrok http -host-header=govcraft.test govcraft.test:80

AWS SES의 해당 Email Address에서 Notifications 설정합니다.
arn:aws:sns:***는 AWS SNS 구독 ID입니다.

```
Bounce Notifications SNS Topic:	arn:aws:sns:***
  Include Original Headers:	enabled
Complaint Notifications SNS Topic: arn:aws:sns:***
  Include Original Headers: enabled
```


### 조직 기본 데이터 등록

```
$ bin/rails organizations:seed
```

## 데이터 정보

### 시의원 데이터 목록

* data/2018_07_seongnam_city_council.xlsx : 2018년 7월 성남시의원 데이터
