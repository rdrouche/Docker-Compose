# ELK

## How to use

- Clone repo on our server
- Edit .env file and edit password
- Edit docker-compose.yml and change folder data for Elasticsearch container : by defaut /containers/data/es0[1-2]/
- Generate certificates : sudo docker-compose -f create-certs.yml run --rm create_certs
- Get image sudo docker-compose pull
- Start containers sudo docker-compose up -d

Enjoy