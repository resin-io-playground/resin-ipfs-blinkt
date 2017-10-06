FROM resin/raspberrypi3-node

WORKDIR /usr/src/app
ENV INITSYSTEM=on

ENV IPFS_VERSION=0.4.11
RUN    curl -O https://ipfs.io/ipns/dist.ipfs.io/go-ipfs/v0.4.11/go-ipfs_v${IPFS_VERSION}_linux-arm.tar.gz \
    && tar xzvf go-ipfs_v${IPFS_VERSION}_linux-arm.tar.gz \
    && cp go-ipfs/ipfs /usr/bin/ipfs \
    && rm -rf go-ipfs*

COPY package.json .
RUN JOBS=MAX npm install --production --unsafe-perm && npm cache clean --force && rm -rf /tmp/*

COPY service/ipfs.service /etc/systemd/system/ipfs.service
COPY . ./

RUN systemctl enable ipfs.service

CMD ["node", "app.js"]
# CMD while : ; do echo "idling..."; sleep 600; done
