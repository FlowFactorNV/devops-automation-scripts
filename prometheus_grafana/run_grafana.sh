docker run -d -p 3000:3000 --name=grafana \
  -v $(pwd)/grafana:/var/lib/grafana \
  --user $(id -u):$(id -g) \
  grafana/grafana-enterprise
