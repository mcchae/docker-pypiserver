# PyPI 서버
===========

이 컨테이너 이미지는 파이썬 pypiserver 를 이용하여 간단한 pypi 서버를 구축합니다.
[코드코알라의 pypi](https://github.com/codekoala/docker-pypi)를 참고하였습니다.

## 사용법

docker가 설치된 머신에서 다음과 같은 명령으로 간단히 실행가능합니다:

    sudo mkdir -p /pypi             	# local directory where packages reside
    sudo touch /pypi/.htpasswd      	# credentials file for adding packages
    docker run -t -i --rm \             # remove container when stopped
        -h pypi.local \                 # hostname
        -v /pypi:/pypi:rw \     		# host packages from local directory
        -p 8080:80 \                    # expose port 80 as port 8080
        --name pypi \                   # container name
    mcchae/pypiserver                	# docker repository

일단 컨테이너가 기동되면 http://localhost:8080 서비스를 이용할 수 있습니다.

`/pypi` 디렉터리에 tar, zip, wheel, egg 등의 패키지를 추가할 수 있고, 해당 저장소를 이용하여 패키지를 설치할 수 있습니다.

## 설정

다음과 같은 환경변수를 이용하여 환경을 다룰 수 있습니다:

* ``PYPI_ROOT``: 패키지가 저장되고 다루어딜 파일 경로입니다. 디폴트는 ``/pypi`` 입니다.
* ``PYPI_PORT``: 서비스 포트 입니다. 디폴트는 ``80`` 입니다.
* ``PYPI_PASSWD_FILE``: 인증 파일을 가리킵니다. 디폴트는 ``/pypi/.htpasswd`` 입니다.
* ``PYPI_OVERWRITE``: 이미 존재하는 패키지를 덮어 쓸지에 대한 플래그입니다. 디폴트는 ``false`` 입니다.
* ``PYPI_AUTHENTICATE``: 인증할 액션 (대소문자 구분 없음) 목록 입니다. 디폴트는 `update` 입니다.
* ``PYPI_EXTRA``: ``pypi-server``에 주어질 기타 옵션입니다.

## 내부 패키지 등록

내부 패키지를 하나 등록하기 이전에 제일 첫번째 해야할 일은 인증 관련된 사용자 정보를 등록하는 것입니다.

    htpasswd -s /pypi/.htpasswd yourusername

> 위의 명령을 실행시킬 때마다 다시 컨테이너를 기동시켜야 합니다.

위의 명령은 대부분의 아파치 패키지를 설치하면 제공해주는데 사용자 이름을 입력받고 암호를 넣게 되어 있습니다. 이렇게 입력한 사용자 이름과 암호는 나중에 안전한 PyPI 업로드를 위하여 사용자 홈 디렉터리 아래에 `~/.pypirc` 에 아래와 같이 기술하면 됩니다. (만약 없으면 생성) 아래의 내용에서 `yourusername` 과
`yourpassword` 의 내용에는 `htpasswd` 명령에 의해 만들었던 사용자 이름과 암호를 넣어 줍니다.:

    [distutils]
    index-servers =
        pypi
        internal

    [pypi]
    username:pypiusername
    password:pypipassword

    [internal]
    repository: http://localhost:8080
    username:yourusername
    password:yourpassword

다음에는 일반적인 `setup.py` 를 이용한 파이썬 생성 작업에서 다음과 명령을 주어 로컬 저장소에 저장하도록 하면 됩니다.

    python setup.py sdist upload -r internal

PyPI 서비스가 정상적으로 동작하고 있고, 사용자 이름과 암호가 모두 맞는다고 가정합니다.

## 다른 외부 패키지 추가

외부 서드파티 패키지는 아래의 명령을 이용합니다. (`pkgname` 대신 원하는 패키지 명을 입력합니다)

    pip install -d /pypi pkgname

마약 requirements.txt를 이용한 여러개의 패키지를 한꺼번에 등록하고자 한다면, 다음과 같이 합니다.

    pip install -d /pypi -r requirements.txt


## 미러링 된 패키지의 업데이트

위에서 추가된 외부 패키지를 한꺼번에 업데이트 하려면 다음과 같이 하면 됩니다:

    pypi-server -U /pypi

모든 개별 패키지가 업데이트 됩니다.