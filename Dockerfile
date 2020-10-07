##
# Build a docker image to run the pingmesh application.
# The CloudWatch version requires /bin/sh, so build from Alpine.
##
FROM alpine:3.12

RUN apk update && apk add ca-certificates && /bin/rm -rf /var/cache/apk/*
RUN apk add --no-cache curl

ADD cmd/pingmesh/pingmesh.exe /usr/local/bin/pingmesh

# Include -c option to publish to CloudWatch.  You must also set the following
# environment variables: AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY.
# Include -v option to turn on verbose logging.
# -N for NATS URL comma-list, -C for path to nats creds,
# -H to override the hostname/IP from the auto-discover,
# -s to set the port
ENTRYPOINT [ "/usr/local/bin/pingmesh", "-N", "tls://connect.ngs.global", "-C", "/etc/ngs/pingtest.creds", "-s", "2002" ]
