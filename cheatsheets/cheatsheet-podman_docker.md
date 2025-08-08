# 🐳 Podman vs Docker Cheatsheet (with Pod Support)

## 🔧 Basic Container Commands

| **Action**                         | **Docker Command**                      | **Podman Command**                     |
|------------------------------------|------------------------------------------|----------------------------------------|
| Check version                      | `docker --version`                       | `podman --version`                     |
| Run container                      | `docker run [opts] IMAGE`                | `podman run [opts] IMAGE`              |
| List running containers            | `docker ps`                              | `podman ps`                            |
| List all containers                | `docker ps -a`                           | `podman ps -a`                         |
| Start/Stop container               | `docker start/stop CONTAINER`            | `podman start/stop CONTAINER`          |
| Remove container                   | `docker rm CONTAINER`                    | `podman rm CONTAINER`                  |
| Remove image                       | `docker rmi IMAGE`                       | `podman rmi IMAGE`                     |
| List images                        | `docker images`                          | `podman images`                        |
| Pull/Push image                    | `docker pull/push IMAGE`                 | `podman pull/push IMAGE`               |
| Build image                        | `docker build -t NAME .`                 | `podman build -t NAME .`               |
| Tag image                          | `docker tag SRC DEST`                    | `podman tag SRC DEST`                  |
| Inspect container/image            | `docker inspect NAME`                    | `podman inspect NAME`                  |
| View logs                          | `docker logs CONTAINER`                  | `podman logs CONTAINER`                |
| Exec into container                | `docker exec -it CONTAINER bash`         | `podman exec -it CONTAINER bash`       |
| Login/Logout to registry           | `docker login/logout`                    | `podman login/logout`                  |
| Save/Load image to/from file       | `docker save/load`                       | `podman save/load`                     |
| Create container (not run)         | `docker create IMAGE`                    | `podman create IMAGE`                  |

---

## 📦 Podman Pods vs Docker Workarounds

> Podman pods are similar to Kubernetes pods (shared network/IPC). Docker doesn't have direct support but you can use `docker-compose` for similar results.

| **Podman Action**                  | **Podman Command**                          | **Docker Alternative**                                   |
|------------------------------------|---------------------------------------------|----------------------------------------------------------|
| Create pod                         | `podman pod create [opts]`                  | _No direct equivalent_ — use `docker-compose` networks   |
| List pods                          | `podman pod ls`                             | _No direct equivalent_                                   |
| Inspect pod                        | `podman pod inspect POD`                    | _No direct equivalent_                                   |
| Add container to pod              | `podman run --pod POD_NAME IMAGE`           | Use `docker-compose` services with shared network        |
| View pod stats                     | `podman pod stats`                          | `docker stats` (container-level only)                    |
| Stop pod                           | `podman pod stop POD`                       | `docker stop $(docker ps -q --filter "label=pod=XYZ")`   |
| Start pod                          | `podman pod start POD`                      | Manually start containers or use `docker-compose up`     |
| Remove pod                         | `podman pod rm POD`                         | Manually remove related containers                       |
| View pod logs                      | `podman pod logs POD`                       | Use `docker-compose logs`                                |

---

## 🧠 Key Notes

- 🔒 **Podman is rootless by default**.
- 🚫 **No daemon**: Podman is daemonless.
- ⚙️ Use `podman-docker` to alias Docker CLI to Podman.
- 📦 **Pods** in Podman share network/IPC like Kubernetes.
- 🧰 Use `docker-compose` or Kubernetes in Docker for similar multi-container behavior.

