FROM verdaccio/verdaccio

USER root
RUN apk --no-cache add python make

ENV NODE_ENV=production
RUN npm install && npm install verdaccio-aws-s3-storage

USER verdaccio
