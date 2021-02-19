FROM node:12-alpine as dependencies


WORKDIR /app/my-app/frontend
COPY ./my-app/frontend/package.json ./my-app/frontend/package-lock.json ./
RUN npm install --only=production --silent
COPY ./my-app/frontend/public ./public
COPY ./my-app/frontend/src ./src
COPY ./my-app/frontend/tsconfig.json .
RUN npm run build

## production image
FROM node:12-alpine as production
LABEL name=cps-my-app-frontend
RUN npm install -g serve



WORKDIR /app/my-app/frontend
COPY --from=dependencies /app/my-app/frontend/build ./build
COPY ./my-app/frontend/public ./public

EXPOSE 80
CMD ["serve", "-s", "build", "-l", "80"]
