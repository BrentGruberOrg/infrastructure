#cloud-config
apt:
  sources:
    tailscale.list:
      source: deb https://pkgs.tailscale.com/stable/ubuntu jammy main
      keyid: 2596A99EAAB33821893C0A79458CA832957F5868
    doppler.list:
      source: deb https://packages.doppler.com/public/cli/deb/debian any-version main
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v2

        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
        j5/gBXtpXqv48Q2Pjlqi7i0/eAFjScCnC7pA
        =R8R8
        -----END PGP PUBLIC KEY BLOCK-----
packages:
  - curl
  - wget
  - openssh-server
  - tailscale
  - doppler
runcmd:
 - |
   echo ${doppler_token} | sudo doppler configure set token --scope /
   cat /root/.doppler/.doppler.yaml
   doppler setup
   cat > /lib/systemd/system/tailscale.service <<'EOF'
   [Unit]
   Description=Tailscale client
   After=tailscale.service

   [Service]
   LimitMEMLOCK=infinity
   User=root
   Group=root
   Type=simple
   ExecStart=doppler run --command 'sudo /usr/bin/tailscale up -authkey $TAILSCALE_TOKEN'
   Restart=on-failure

   [Install]
   WantedBy=multi-user.target
   EOF
   systemctl daemon-reload
   systemctl enable tailscale.service
   systemctl start tailscale.service

   curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik --secrets-encryption" sh -s -
   kubectl apply -k 'github.com/BrentGruberOrg/tools-deploy/argo/argocd?ref=main'
   kubectl apply -k 'github.com/BrentGruberOrg/tools-deploy/apps/profiles/tools?ref=main'

   /home/ubuntu/wait-for.sh doppler-operator-system

   wget https://github.com/BrentGruberOrg/doppler-secrets-bootstrap/raw/main/doppler-bootstrap-arm64
   chmod +x ./doppler-bootstrap-arm64
   mkdir /root/.kube && cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
   HOME=/root doppler run ./doppler-bootstrap-arm64

   /home/ubuntu/wait-for.sh ingress-nginx

   CA=$(kubectl -n ingress-nginx get secret ingress-nginx-admission -ojsonpath='{.data.ca}') kubectl patch validatingwebhookconfigurations ingress-nginx-admission -n ingress-nginx --type='json' -p='[{"op": "add", "path": "/webhooks/0/clientConfig/caBundle", "value":"'$CA'"}]'
# https://fabianlee.org/2022/01/29/nginx-ingress-nginx-controller-admission-error-x509-certificate-signed-by-unknown-authority/
  
write_files:
  - content: |
      #!/bin/sh
      iptables -P FORWARD ACCEPT
    path: /etc/rc.local
    permissions: '0755'
  - content: |
      #!/bin/sh
      until [ $(kubectl get ns --no-headers -o custom-columns=":metadata.name") == *"$1"* ];
      do
        echo "waiting for $1 namespace to be created"
        sleep 30
      done

      echo "namespace found"
    path: /home/ubuntu/wait-for.sh
    permission: '0755'