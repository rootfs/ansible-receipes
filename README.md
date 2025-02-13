# Ansible Receipes for AI Gateway

This repository contains Ansible playbooks for deploying an EKS cluster with vLLM, Prometheus monitoring, and Envoy AI Gateway.

## Prerequisites

- AWS CLI configured with appropriate credentials
- `kubectl` installed
- `helm` installed
- `eksctl` installed
- Ansible installed

## Configuration

The main configuration is in `main.yml`. Key variables you might want to customize:

```yaml
# Cluster configuration
cluster_name: "my-eks-cluster"
region: "us-east-1"
node_instance_type: "g4dn.xlarge"

# vLLM Models
vllm_deployments:
  - name: vllm-model-1
    model: "facebook/opt-6.7b"
    header_value: "facebook-opt-6.7b"
    pvc: "model-storage-1"
  - name: vllm-model-2
    model: "microsoft/Phi-3-mini-4k-instruct"
    header_value: "phi-3-mini-4k-instruct"
    pvc: "model-storage-2"
```

## Usage

1. Deploy everything:
```bash
ansible-playbook main.yml
```

2. Deploy specific components:
```bash
# Deploy only vLLM
ansible-playbook main.yml -e "install_vllm=true install_prometheus=false install_envoy=false"

# Deploy vLLM and Envoy Gateway
ansible-playbook main.yml -e "install_vllm=true install_prometheus=false install_envoy=true"

# Deploy everything except Prometheus
ansible-playbook main.yml -e "install_prometheus=false"
```

3. Clean up all resources:
```bash
ansible-playbook main.yml -e "cleanup=true"
```

## Components

- **EKS Cluster**: Deploys a Kubernetes cluster with GPU nodes
- **vLLM**: Deploys specified LLM models with OpenAI-compatible API
- **Prometheus**: Monitoring stack with Grafana dashboard
- **Envoy AI Gateway**: Load balancing and routing for LLM models


### Testing vLLM Models
Once deployed, you can test the models using curl:
```bash
curl -X POST \
  http://<gateway-url>/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "x-ai-eg-model: facebook/opt-6.7b" \
  -d '{
    "messages": [
      {"role": "user", "content": "What is machine learning?"}
    ],
    "temperature": 0.7,
    "max_tokens": 150
  }'
```

## Directory Structure
```
ansible-receipes/
├── main.yml                 # Main playbook
├── tasks/
│   ├── storage-setup.yml    # EBS storage setup
│   ├── vllm-deploy.yml      # vLLM deployment
│   ├── prometheus-deploy.yml # Prometheus stack
│   ├── envoy-deploy.yml     # Envoy Gateway
│   └── cleanup.yml          # Resource cleanup
└── templates/
    ├── phi-chat-template.yaml
    └── opt-chat-template.yaml
```

## Notes

- The playbook creates necessary storage classes and PVCs for model storage
- GPU nodes are required for running the LLM models
- All components are optional and can be enabled/disabled as needed
- Cleanup process will remove all AWS resources created by the playbook

