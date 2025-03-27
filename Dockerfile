# Use newer Node image (comes with updated Yarn)
FROM node:20 AS build

WORKDIR /app

# First copy only package files
COPY package.json yarn.lock ./

# Clean cache and install (without frozen-lockfile first)
RUN yarn cache clean && yarn install

# Then copy everything else
COPY . .

# Now run build
RUN yarn build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
