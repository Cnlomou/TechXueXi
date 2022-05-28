
FROM python:3.7-slim
ARG usesource="https://github.com/Cnlomou/TechXueXi.git"
ARG usebranche="dev"
ENV pullbranche=${usebranche}
ENV Sourcepath=${usesource}
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update; \
    apt-get install -y wget unzip libzbar0 git cron supervisor dos2unix
ENV TZ=Asia/Shanghai
ENV AccessToken=
ENV Secret=
ENV Nohead=True
ENV Pushmode=1
ENV MaxWorkers=4
ENV islooplogin=False
ENV CRONTIME=30 9 * * *
# RUN rm -f /xuexi/config/*; ls -la
COPY requirements.txt /xuexi/requirements.txt
COPY run.sh /xuexi/run.sh 
COPY start.sh /xuexi/start.sh 
COPY supervisor.sh /xuexi/supervisor.sh

RUN pip install -r /xuexi/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN cd /xuexi/; \
  wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_92.0.4515.159-1_amd64.deb; \
  dpkg -i google-chrome-stable_92.0.4515.159-1_amd64.deb; \
  apt-get -fy install; \
  google-chrome --version; \
  rm -f google-chrome-stable_92.0.4515.159-1_amd64.deb
RUN cd /xuexi/; \
  wget -O chromedriver_linux64_92.0.4515.107.zip http://npm.taobao.org/mirrors/chromedriver/92.0.4515.107/chromedriver_linux64.zip; \
  unzip chromedriver_linux64_92.0.4515.107.zip; \
  chmod 755 chromedriver; \
  ls -la; \
  ./chromedriver --version
RUN apt-get clean
WORKDIR /xuexi
RUN chmod +x ./run.sh
RUN chmod +x ./start.sh
RUN chmod +x ./supervisor.sh; \
    dos2unix ./supervisor.sh; \
    dos2unix ./run.sh; \
    dos2unix ./start.sh;
RUN mkdir code
WORKDIR /xuexi/code
RUN git config --global url."https://hub.fastgit.xyz/".insteadOf "https://github.com/"; \
    git clone -b ${usebranche} ${usesource}; \
    cp -r /xuexi/code/TechXueXi/SourcePackages/* /xuexi;
COPY ./SourcePackages /xuexi/
WORKDIR /xuexi
EXPOSE 80
ENTRYPOINT ["/bin/bash", "./start.sh"]
