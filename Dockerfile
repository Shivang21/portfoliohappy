

# build environment
# FROM node:14.17 as react-build
# #WORKDIR /app
# COPY . ./
# RUN npm install
# RUN npm run build

# # # server environment
# FROM nginx:alpine
# COPY nginx.conf /etc/nginx/conf.d/configfile.template

# COPY --from=react-build /app/build /usr/share/nginx/html

# ENV PORT 3000
# ENV HOST 0.0.0.0
# EXPOSE 3000
# CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'" 


FROM node:14-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine

# Copy build files from the previous stage to Nginx server directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
