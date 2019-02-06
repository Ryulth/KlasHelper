FROM ubuntu:16.04
MAINTAINER adboy94@khu.ac.kr

ENV LANG C.UTF-8
ENV         TZ 'Asia/Seoul'
RUN         echo $TZ > /etc/timezone && apt-get update && apt-get install -y tzdata && rm /etc/localtime && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && apt-get clean

RUN apt-get -y update
RUN apt-get install -y python-pip git vim
RUN apt-get install -y python3-software-properties
RUN apt-get install -y software-properties-common
RUN apt-get -y update
RUN apt-get install -y python3-pip

RUN python3 -m pip install --upgrade pip
RUN pip3 install django~=2.1.2
RUN apt-get install -y nginx
RUN apt-get install -y screen
RUN pip3 install numpy
RUN pip3 install pandas
RUN pip3 install pymysql
RUN pip3 install requests
RUN pip3 install beautifulsoup4
RUN pip3 install virtualenv
RUN pip3 install uwsgi
RUN pip3 install django-rest-swagger
RUN apt-get install -y uwsgi
RUN apt-get install -y uwsgi-plugin-python3

