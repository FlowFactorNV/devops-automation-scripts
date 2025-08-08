# 🧭 OpenShift vs Kubernetes CLI Cheat Sheet

| **Task**                            | **Kubernetes (`kubectl`)**                     | **OpenShift (`oc`)**                          |
|-------------------------------------|------------------------------------------------|-----------------------------------------------|
| **Login to Cluster**               | `kubectl config set-context ...`              | `oc login https://<cluster-url>`              |
| **List Projects / Namespaces**     | `kubectl get namespaces`                      | `oc get projects`                             |
| **Switch Namespace / Project**     | `kubectl config set-context --current --namespace=<ns>` | `oc project <project-name>`           |
| **View Resources (Pods, etc.)**    | `kubectl get pods`                            | `oc get pods`                                 |
| **Describe a Resource**            | `kubectl describe pod <pod-name>`             | `oc describe pod <pod-name>`                  |
| **Create from YAML**               | `kubectl apply -f <file>.yaml`                | `oc apply -f <file>.yaml`                     |
| **Edit a Resource**                | `kubectl edit <resource>/<name>`              | `oc edit <resource>/<name>`                   |
| **Delete a Resource**              | `kubectl delete <resource>/<name>`            | `oc delete <resource>/<name>`                 |
| **View Logs**                      | `kubectl logs <pod>`                          | `oc logs <pod>`                               |
| **Exec into a Pod**                | `kubectl exec -it <pod> -- /bin/bash`         | `oc rsh <pod>` *(or `oc exec`)*               |
| **Port Forwarding**                | `kubectl port-forward svc/<service> 8080:80`  | `oc port-forward svc/<service> 8080:80`       |
| **Get All Resources**              | `kubectl get all`                             | `oc get all`                                  |
| **Deploy an App**                  | *(use YAML or Helm)*                          | `oc new-app <image or template>`              |
| **Expose a Service**               | `kubectl expose pod <pod> --port=80`          | `oc expose svc/<svc-name>`                    |
| **Scale Deployment**               | `kubectl scale deployment <name> --replicas=N`| `oc scale dc/<name> --replicas=N`             |
| **Rollout Status**                 | `kubectl rollout status deployment/<name>`    | `oc rollout status dc/<name>`                 |
| **View Cluster Info**              | `kubectl cluster-info`                        | `oc status`                                   |
| **Get Current User**               | `kubectl config view --minify -o jsonpath='{.users[0].name}'` | `oc whoami`                     |
| **Start Build (for Source Builds)**| *(not used)*                                  | `oc start-build <build-config>`               |
| **Tag Images**                     | `kubectl annotate` or use `docker tag`        | `oc tag <source-image> <destination-image>`   |
| **Get Routes (Ingress)**           | `kubectl get ingress`                         | `oc get routes` *(OpenShift uses Routes)*     |

---

### 📝 Notes:
- `kubectl` works for all Kubernetes clusters, including OpenShift.
- `oc` is OpenShift’s CLI and includes additional functionality (like `oc new-app`, `oc get routes`, etc.).
- OpenShift often uses *DeploymentConfigs (dc)* instead of standard *Deployments*, though support for both exists.
