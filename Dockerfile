docker network create opensearch-net
docker volume create opensearch-data1
docker volume create opensearch-data2

# Run OpenSearch Node 1
docker run -d \
--name opensearch-node1 \
--network opensearch-net \
-p 9200:9200 \
-p 9600:9600 \
-e cluster.name=opensearch-cluster \
-e node.name=opensearch-node1 \
-e discovery.seed_hosts=opensearch-node1,opensearch-node2 \
-e cluster.initial_cluster_manager_nodes=opensearch-node1,opensearch-node2 \
-e bootstrap.memory_lock=true \
-e OPENSEARCH_JAVA_OPTS="-Xms512m -Xmx512m" \
-e OPENSEARCH_INITIAL_ADMIN_PASSWORD=YourStr0ng!Password \
--ulimit memlock=-1:-1 \
--ulimit nofile=65536:65536 \
-v opensearch-data1:/usr/share/opensearch/data \
opensearchproject/opensearch:3

# Run OpenSearch Node 2
docker run -d \
--name opensearch-node2 \
--network opensearch-net \
-e cluster.name=opensearch-cluster \
-e node.name=opensearch-node2 \
-e discovery.seed_hosts=opensearch-node1,opensearch-node2 \
-e cluster.initial_cluster_manager_nodes=opensearch-node1,opensearch-node2 \
-e bootstrap.memory_lock=true \
-e OPENSEARCH_JAVA_OPTS="-Xms512m -Xmx512m" \
-e OPENSEARCH_INITIAL_ADMIN_PASSWORD=YourStr0ng!Password \
--ulimit memlock=-1:-1 \
--ulimit nofile=65536:65536 \
-v opensearch-data2:/usr/share/opensearch/data \
opensearchproject/opensearch:3

# Run OpenSearch Dashboards (UI)
docker run -d \
--name opensearch-dashboards \
--network opensearch-net \
-p 5601:5601 \
-e OPENSEARCH_HOSTS='["https://opensearch-node1:9200","https://opensearch-node2:9200"]' \
opensearchproject/opensearch-dashboards:3

# Access the UI
http://localhost:5601
username: admin
password: YourStr0ng!Password
