# Use a newer Node image
FROM node:20 AS build

WORKDIR /app

# Copy package files first
COPY package.json yarn.lock ./

# Clean Yarn cache and install dependencies
RUN yarn cache clean && yarn install --no-lockfile

# Alternatively, you can upgrade Yarn and install dependencies like this:
# RUN npm install -g yarn@latest && yarn cache clean && yarn install --frozen-lockfile

# Copy the rest of the application files
COPY . .

# Build the application
RUN yarn build

# Use Nginx to serve the build output
FROM nginx:alpine

# Copy the build output from the previous stage to Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
