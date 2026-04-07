# Baremetal Network Tester

A Helm chart that deploys pre-flight network validation jobs onto an OpenShift
cluster. Each job runs connectivity tests against a set of IP/port/protocol
combinations defined in CSV files.

## Purpose

Before deploying workloads that depend on specific network paths (MetalLB VIPs,
Multus secondary networks, SR-IOV interfaces), this tool verifies reachability
from the cluster nodes to the target endpoints.

## How to use

1. Create CSV files under `files/<cluster-name>/` with columns: `ip,port,protocol,description`
2. Create test scripts under `files/` that consume the CSVs and run connectivity checks
3. Customise `values.yaml` for your cluster (namespace, node selectors, etc.)
4. Deploy with Helm:

```bash
helm install network-test . -n pre-flight --create-namespace \
  -f values.yaml
```

5. Check pod logs for test results

## CSV Format

```csv
ip,port,protocol,description
192.0.2.100,80,tcp,Example MetalLB VIP - HTTP
192.0.2.100,443,tcp,Example MetalLB VIP - HTTPS
```

See `files/example/` for a sample CSV.

## Structure

```
Chart.yaml          - Helm chart metadata
values.yaml         - Default configuration values
templates/          - Kubernetes resource templates
files/              - Test scripts and per-cluster CSV data
  example/          - Example CSV showing the format
```
