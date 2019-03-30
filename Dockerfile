#Docker file not working because bootstrap and jquery files were 
#externally added in node module dist folder and not by npm install
#so when we..
#docker build -t angular-blogger-app .
# we get a ERROR


# STEP 1 build static website
FROM node:alpine as builder
#RUN apk update && apk add --no-cache make git
# Create app directory
WORKDIR /app
# Install app dependencies
COPY package.json package-lock.json   /app/
RUN cd /app && npm set progress=false && npm install
# Copy project files into the docker image
COPY .  /app
COPY /app/node_modules/bootstrap/dist/js/J /app/node_modules/bootstrap/dist/js/
RUN cd /app && npm run build

# STEP 2 build a small nginx image with static website
FROM nginx:alpine
## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
## From 'builder' copy website to default nginx public folder
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]