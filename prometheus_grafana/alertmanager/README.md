
# Alertmanager Setup

This folder provides a sample configuration to help you add Alertmanager to your Prometheus setup.

Before you begin, ensure you have the following installed:
- **Docker** (for running Alertmanager)
- **Prometheus** (installed and running)
- **Grafana** (optional, for visualization)

---

## Setting Up Prometheus

To integrate the provided alert rules with your Prometheus setup, add the following configuration to your `prometheus.yml` file:

```yaml
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - 'localhost:9093'  # Replace with your Alertmanager IP if different

rule_files:
  - 'alertrules/alerts.yml'  # Path to your alert rules file
```
Make sure the alerts.yml file is accessible at the specified path.

---

Example Rule from alerts.yml

## Alert Rules Configuration

The `alerts.yml` file contains predefined alert rules for common monitoring scenarios. These include:

1. **InstanceDown**: Triggers when an instance is down.
2. **HostOutOfMemory**: Triggers when available memory drops below 10%.
3. **HostOutOfSwap**: Triggers when swap memory drops below 25%.
4. **HostOutOfDiskSpace**: Triggers when disk space drops below 20%.
5. **HostHighCpuLoad**: Triggers when CPU load exceeds 80%.

You can customize these rules or add new ones as needed.

### Example Rule from `alerts.yml`
```yaml
groups:
- name: alert_rules
  rules:
  - alert: InstanceDown
    expr: up == 0
    for: 1m
    labels:
      severity: "critical"
    annotations:
      summary: "Instance is down (instance {{ $labels.instance }})"
      description: "{{ $labels.instance }} ({{ $labels.environment }} environment) is down"
```

## Running Alertmanager

To run Alertmanager using Docker, use the provided `run_alertmanager.sh` script:

```yaml
docker run --name alertmanager -d \
  -p 127.0.0.1:9093:9093 quay.io/prometheus/alertmanager
```
This script starts an Alertmanager container on port 9093. You can modify the port or IP binding as needed.

---

## Files Overview

### `alerts.yml`
Contains predefined alert rules for monitoring various metrics such as CPU, memory, disk space, and instance availability.

### `run_alertmanager.sh`
A simple script to start an Alertmanager container using Docker.

---

## Disclaimer

This repository is provided "as-is" without any warranties or guarantees of functionality. Use it at your own risk and ensure you test all configurations thoroughly before deploying them in production environments. Contributions and feedback are welcome!

