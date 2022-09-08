# Build Phase
FROM node:16-alpine AS builder

USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY package.json ./
RUN npm install

COPY --chown=node:node ./ ./

RUN npm run build
# build output is in ~/app/build

# Run Phase
FROM nginx

# expose the port 80 to outside the container
#  does nothing in development, but AWS EBS will
#  find this during the deploy and expose it 
EXPOSE 80

# copy the build output from the previous section 
COPY --from=builder /home/node/app/build /usr/share/nginx/html

# nginx container automatically takes care of the command