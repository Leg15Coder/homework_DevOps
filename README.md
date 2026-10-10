## Инструкция по развёртыванию

1. **Terraform**:

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

2. **Ansible**:

```bash
cd ansible
ansible-playbook -i inventory.ini setup_host.yml
```

3. **Monitoring**:

```bash
cd scripts
./monitor.sh docker
```

4. **Docker Compose**:

```bash
cd /opt/app
docker compose up -d
curl http://localhost
```
