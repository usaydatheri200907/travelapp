# Use an official Node.js runtime as the base image
FROM node:18 as build

# Set the working directory
WORKDIR /app

# Install Yarn globally (if not already included)
RUN npm install -g yarn

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies (with frozen lockfile to avoid changes)
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the application
RUN yarn build

# Use a lightweight web server to serve the built files
FROM nginx:alpine

# Copy the built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
