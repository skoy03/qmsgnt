FROM registry.cn-guangzhou.aliyuncs.com/qmsgnt/node:20.12
MAINTAINER DIEYI from NapCatQQ
# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Acquire::https::Verify-Peer "false";' >> /etc/apt/apt.conf.d/99noverify
COPY sources.list /etc/apt/sources.list
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    libnss3 \
    libnotify4 \
    libsecret-1-0 \
    libgbm1 \
    libasound2 \
    fonts-wqy-zenhei \
    gnutls-bin \
    libglib2.0-dev \
    libdbus-1-3 \
    libgtk-3-0 \
    libxss1 \
    libxtst6 \
    libatspi2.0-0 \
    libx11-xcb1 \
    ffmpeg \
    unzip \
    openbox \
    xorg \
    dbus-user-session \
    xvfb \
    supervisor \
    xdg-utils \
    git \
    fluxbox \
    curl && \
    apt-get clean --no-install-recommends && \
    apt autoremove -y && \
    apt clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

WORKDIR /usr/src/app

COPY start.sh ./start.sh

RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    curl -o linuxqq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.12_240819_${arch}_01.deb && \
    dpkg -i --force-depends linuxqq.deb && rm linuxqq.deb && \
    chmod +x start.sh && \
    echo "(async () => {await import('file:///usr/src/app/QmsgNtClient-NapCatQQ/napcat.mjs');})();" > /opt/QQ/resources/app/app_launcher/index.js

RUN curl -L -o /tmp/QmsgNtClient-NapCatQQ.zip https://cdn.ooomn.cn/QmsgNtClient-NapCatQQ/download/v$(curl https://cdn.ooomn.cn/QmsgNtClient-NapCatQQ/package.json | grep '"version":' | sed -E 's/.*([0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}).*/\1/')/QmsgNtClient-NapCatQQ.zip
RUN unzip -o /tmp/QmsgNtClient-NapCatQQ.zip -d ./QmsgNtClient-NapCatQQ
RUN cd ./QmsgNtClient-NapCatQQ && npm config set registry https://mirrors.cloud.tencent.com/npm/ && npm i

VOLUME /usr/src/app/QmsgNtClient-NapCatQQ/config
VOLUME /usr/src/app/QmsgNtClient-NapCatQQ/logs
VOLUME /root/.config/QQ

ENTRYPOINT ["bash", "start.sh"]
