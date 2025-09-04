FROM node:20-alpine3.21 AS builder
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install  
# It's better to use npm install before after package.json as if any change in source code the cache will be nullfied and again npm install will run. usually npm install should be run only when chages in package.json

FROM node:20-alpine3.21
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
COPY --from=builder /opt/server /opt/server 
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
WORKDIR /opt/server    
USER roboshop    
CMD ["node","server.js"] 
   
