# Use newer Node image (comes with updated Yarn)
FROM node:20 AS build

WORKDIR /app

# Copy only package files first to leverage Docker cache
COPY package.json yarn.lock ./

# Clean cache and install dependencies
RUN yarn cache clean && yarn install --frozen-lockfile

# Copy the rest of the application files
COPY . .

# Build the app
RUN yarn build

# Use Nginx to serve the build output
FROM nginx:alpine

# Copy the build output from the previous stage to Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
