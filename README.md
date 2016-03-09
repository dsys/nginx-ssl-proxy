# nginx-ssl-proxy

Nginx reverse proxy for SSL termination inside Kubernetes clusters with Let's Encrypt certificates.

## Usage

Available on Docker Hub as [pavlov/nginx-ssl-proxy](https://hub.docker.com/r/pavlov/nginx-ssl-proxy). Designed to work with [ployst/letsencrypt](https://hub.docker.com/r/ployst/letsencrypt/).

The nginx instance acts as a reverse proxy, providing SSL termination for other services in the cluster. SSL certificates, keys, and other secrets are managed via Kubernetes secrets.

```yaml
kind: ReplicationController
apiVersion: v1
metadata:
  namespace: default
  name: nginx-ssl-proxy
spec:
  replicas: 2
  selector:
    app: nginx-ssl-proxy
  template:
    metadata:
      labels:
        app: nginx-ssl-proxy
    spec:
      containers:
      - name: nginx-ssl-proxy
        image: pavlov/nginx-ssl-proxy:latest
        env:
        - name: SERVICE_HOST_ENV_NAME
          value: API_SERVICE_HOST
        - name: SERVICE_PORT_ENV_NAME
          value: API_SERVICE_PORT
        - name: CERT_SERVICE_HOST_ENV_NAME
          value: LETSENCRYPT_SERVICE_HOST
        - name: CERT_SERVICE_PORT_ENV_NAME
          value: LETSENCRYPT_SERVICE_PORT
        ports:
        - name: http
          containerPort: 80
        - name: https
          containerPort: 443
        volumeMounts:
        - name: secrets
          mountPath: /etc/secrets
          readOnly: true
      volumes:
      - name: secrets
        secret:
          secretName: letsencrypt-cert
```

## Generating test certificates

**THIS IS NOT FOR PRODUCTION USE.**

Use the `setup-certs.sh` script to generate test certificates. It will create your own Certificate Authority and use that to self sign a certificate.

    ./setup-certs.sh /path/to/certs/folder

## Development

    $ make build
    $ make push

## License

[Apache 2](https://github.com/pavlovml/nginx-ssl-proxy/blob/master/LICENSE)
