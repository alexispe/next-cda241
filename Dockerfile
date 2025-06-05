FROM node:24-alpine3.22 AS builder

LABEL org.opencontainers.image.source=https://github.com/alexispe/next-cda241

COPY . /app/

WORKDIR /app

RUN npm install
RUN npm run build


FROM node:24-alpine3.22 AS next

COPY --from=builder /app/.next /app/.next
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json

WORKDIR /app

EXPOSE 3000

COPY docker/next/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
CMD ["npm", "run", "start"]
