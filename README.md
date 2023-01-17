
## Kubernetes CSVServer Assignment
We will be deploying the csvserver application in the local Kubernetes cluster along with Prometheus to monitor it. It is a web server which reads a CSV file from disk and makes it available as HTML.

### Instructions for the assignment
As part of the assignment, you will be writing Kubernetes manifests (YAMLs) for various resources like ConfigMap, Deployment, Service etc.

#### Before we start
- Use an IDE / editor with support for YAML, so that you get the indentation correct. Example: VSCode.
- You **don’t have to** write all the YAMLs from scratch, you can take reference from the previous hands-on activities. Build on top of the YAMLs from there.
- Open the following links in your browser, and save them on your machine.
  - [csvserver/inputdata-csv](https://github.com/infracloudio/citadel-internal/raw/k8s_mod_update/workshops/kubernetes/csvserver/inputdata-csv) 
  - [csvserver/prometheus-cm.yaml](https://github.com/infracloudio/citadel-internal/raw/k8s_mod_update/workshops/kubernetes/csvserver/prometheus-cm.yaml) 

#### csvserver
Create a ConfigMap in `configmap.yaml`
- Set the metadata.name to `csvserver-input`.
- The content of `inputdata-csv` file should be available as inputdata key in the ConfigMap.
- *Hint: You might need to use `|` character in the YAML.*

Create a Deployment in `deployment.yaml`
- Set the name to `csvserver`.
- Use container image `docker.io/infracloudio/csvserver:latest`.
- Set the environment variable `CSVSERVER_BORDER` to `Blue` for the pod.
- Mount the `csvserver-input` ConfigMap in the pod such that it creates the file `inputdata` inside the directory `/csvserver`.

Create a Service for csvserver Deployment in `service.yaml`
- Set the name to `csvserver`.
- This service will listen on the port `80`.
- The csvserver application listens on the port `9300`.

Try to access the service by port-forwarding to it with the command:

```bash
kubectl port-forward service/csvserver 8080:80
```

#### Prometheus
Create the Prometheus configuration
- Modify the `prometheus-cm.yaml` and replace `&lt;csvserver FQDN here>` with the FQDN of the `csvserver` Service.
- Apply the ConfigMap
  ```bash
  kubectl apply -f prometheus-cm.yaml
  ```

Create a StatefulSet in `prometheus-sts.yaml`
- Set the name to `prometheus`.
- Number of replicas is 1.
- Use container image `docker.io/prom/prometheus:v2.36.2`.
- Mount the Prometheus ConfigMap in a way that the `prometheus.yml` key is available as `prometheus.yml` file inside the directory `/etc/prometheus/`.
- Set volumeClaimTemplate to create 1Gi of PersistentVolumeClaim for the pods.
- Mount the volume at `/prometheus`, this is the location where Prometheus will save its data.

Create a Service in `prometheus-svc.yaml`
- Set the name to `prometheus`.
- This service will listen on the port `9090`.
- The Prometheus container listens on the port `9090`.

Try to access the service by port-forwarding to it with the command:

```bash
kubectl port-forward service/prometheus 9090:9090
```

### Expected output
- When `kubectl port-forward service/csvserver 8080:80` is executed, [http://localhost:8080](http://localhost:8080) should show csvserver with blue border.
- When `kubectl port-forward service/prometheus 9090:9090` is executed [http://localhost:9090/targets](http://localhost:9090/targets) is accessible, and shows csvserver as a healthy target.
- Running `kubectl get pvc` shows a PVC for Prometheus.

