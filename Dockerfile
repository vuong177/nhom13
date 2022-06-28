FROM faddat/archlinux AS builder

ENV GOPATH /go
ENV PATH $PATH:/go/bin

RUN pacman -Syyu --noconfirm go base-devel rocksdb

COPY . /craft

RUN cd /craft && \
    go install ./...

FROM faddat/archlinux

ENV CRAFT_P2P_MAX_NUM_INBOUND_PEERS=500
ENV CRAFT_P2P_MAX_NUM_OUTBOUND_PEERS=60
ENV CRAFT_P2P_SEED_MODE=true

RUN pacman -Syyu --noconfirm 

COPY --from=builder /go/bin/nhom13 /usr/bin/nhom13
