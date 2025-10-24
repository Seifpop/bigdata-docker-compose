# Big Data Platform: Hadoop, Hive, Spark, Flink, HBase, Sqoop, Zeppelin, Kafka via Docker Compose

**Author:** Seifeddine Abdelhak

A comprehensive big data platform that provides an easy way to experiment with various big data technologies through Docker containers. Everything can be started and stopped with simple commands.

## Version Information

| Component | Version |
|-----------|---------|
| Hadoop | 3.2.3 |
| Hive | 3.1.2 |
| HBase | 2.3.6 |
| Spark | 3.0.0 |
| Flink | 1.13.6 |
| Zeppelin | 0.10.1 |
| Sqoop | 1.4.7 |
| Tez | 0.9.2 |
| Scala | 2.12 |
| Hudi | 0.10.0 |
| Trino | 378 |
| Kafka | 7.5.0 (Confluent) |
| PostgreSQL | 11.5 & 16 |
| MySQL | 8.0 |
| Zookeeper | Latest |

## Architecture Overview

The platform consists of:
- **1 Master Node**: Hadoop NameNode, Spark Master, HBase Master, YARN ResourceManager
- **2 Worker Nodes**: Hadoop DataNodes, Spark Workers, HBase RegionServers, YARN NodeManagers
- **Zeppelin**: Interactive notebook interface
- **Kafka Cluster**: With Zookeeper and Kafka UI
- **Databases**: PostgreSQL (2 instances) and MySQL
- **Zookeeper Ensemble**: 3-node cluster for HBase coordination

## Prerequisites

- **RAM**: Minimum 16GB recommended for your host machine
- **Docker RAM**: Allocate at least 8GB to Docker
- **Disk Space**: More than 90% free space required (YARN requirement)
- **Docker & Docker Compose**: Latest versions installed

## Quick Start

### Clone Repository
```bash
git clone https://github.com/your-repo/bigdata-docker-compose.git
cd bigdata-docker-compose
```

### Start All Services
```bash
docker-compose up -d
```

### Stop All Services
```bash
docker-compose stop
```

### Remove All Containers (Use with caution!)
```bash
docker-compose down
```

### Restart Services
```bash
docker-compose restart
```

## Directory Structure

- **data/**: Shared storage mounted in all containers for input/output files
- **data_share/**: Additional shared volume
- **logs/**: Contains logs for all services (hadoop, hbase, hive, spark, flink, zeppelin)
- **zeppelin_notebooks/**: Persistent storage for Zeppelin notebooks

## Services & Access Points

### Web UI Interfaces

| Service | URL | Description |
|---------|-----|-------------|
| **YARN ResourceManager** | http://localhost:8088 | Hadoop cluster resource management |
| **YARN ResourceManager v2** | http://localhost:8088/ui2 | Alternative YARN interface |
| **Hadoop NameNode** | http://localhost:9870 | HDFS management interface |
| **Hadoop DataNode 1** | http://localhost:9864 | First data node status |
| **Hadoop DataNode 2** | http://localhost:9865 | Second data node status |
| **Hadoop Secondary NameNode** | http://localhost:9868 | Secondary NameNode UI |
| **YARN History Server** | http://localhost:19888 | Job history and logs |
| **Spark Master** | http://localhost:8080 | Spark cluster overview |
| **Spark Worker 1** | http://localhost:8981 | First Spark worker status |
| **Spark Worker 2** | http://localhost:8982 | Second Spark worker status |
| **Spark History Server** | http://localhost:18080 | Completed Spark applications |
| **Spark History API** | http://localhost:18080/api/v1/applications | REST API for Spark history |
| **Spark Job UI** | http://localhost:4040-4043 | Active job monitoring (incremental ports) |
| **HBase Master** | http://localhost:16010 | HBase cluster management |
| **Flink UI (Master)** | http://localhost:45080 | Flink job management on master |
| **Flink UI (Worker1)** | http://localhost:45081 | Flink on worker1 |
| **Flink UI (Worker2)** | http://localhost:45082 | Flink on worker2 |
| **Zeppelin** | http://localhost:8890 | Interactive notebooks |
| **Kafka UI** | http://localhost:8090 | Kafka cluster management |
| **Trino** | http://localhost:28888 | Distributed SQL query engine |

### Database Connections

#### Hive (via JDBC)
- **URI**: `jdbc:hive2://localhost:10000`
- **Driver**: `org.apache.hive.jdbc.HiveDriver`
- **Maven**: `org.apache.hive:hive-jdbc:3.1.2`
- **User**: Not required
- **Password**: Not required

#### PostgreSQL - Hive Metastore
- **Host**: localhost
- **Port**: 5432
- **Database**: Multiple (see init.sql)
- **User**: postgres
- **Password**: new_password

#### PostgreSQL - Additional Server
- **Host**: localhost
- **Port**: 5439
- **Database**: my_postgres_db
- **User**: postgres
- **Password**: root

#### MySQL Server
- **Host**: localhost
- **Port**: 3307
- **Database**: my_mysql_db
- **Root Password**: root
- **User**: admin
- **Password**: admin

### Kafka Configuration
- **Bootstrap Server**: localhost:9092
- **Zookeeper**: localhost:21810
- **Internal Network**: kafka:9092

### Port Reference

| Port | Service | Description |
|------|---------|-------------|
| 2181-2183 | Zookeeper (HBase) | HBase coordination (3 nodes) |
| 3307 | MySQL | MySQL database server |
| 4040-4043 | Spark Jobs | Active Spark job web UIs |
| 5432 | PostgreSQL (Metastore) | Hive metastore database |
| 5439 | PostgreSQL (Additional) | Additional PostgreSQL instance |
| 7077 | Spark Master | Spark master communication |
| 8080 | Spark Master UI | Spark cluster web interface |
| 8088 | YARN ResourceManager | YARN web interface |
| 8090 | Kafka UI | Kafka management interface |
| 8101-8102 | Spark Workers | Worker node job UIs |
| 8890 | Zeppelin | Notebook interface |
| 8981-8982 | Spark Workers UI | Worker status pages |
| 9092 | Kafka | Kafka broker (external) |
| 9864-9865 | Hadoop DataNodes | DataNode web interfaces |
| 9868 | Secondary NameNode | Secondary NameNode UI |
| 9870 | Hadoop NameNode | NameNode web interface |
| 10000 | Hive Server2 | Hive JDBC/Thrift server |
| 10020 | Flink JobManager | Flink job management |
| 16010 | HBase Master | HBase management interface |
| 18080 | Spark History | Spark history server |
| 19888 | YARN History | MapReduce job history |
| 21810 | Zookeeper (Kafka) | Kafka coordination |
| 28888 | Trino | SQL query engine |
| 29092 | Kafka | Kafka broker (internal) |
| 45080-45082 | Flink | Flink web UIs (master + workers) |

## Network Configuration

All services run on the `spark_net` network with subnet `172.28.0.0/16`:

| Hostname | IP Address | Role |
|----------|------------|------|
| master | 172.28.1.1 | NameNode, Spark Master, HBase Master |
| worker1 | 172.28.1.2 | DataNode, Spark Worker, HBase RegionServer |
| worker2 | 172.28.1.3 | DataNode, Spark Worker, HBase RegionServer |
| hivemetastore | 172.28.1.4 | PostgreSQL for Hive metadata |
| zeppelin | 172.28.1.5 | Zeppelin notebook server |
| postgres_server | 172.28.1.6 | Additional PostgreSQL |
| mysql_server | 172.28.1.7 | MySQL database |
| zookeeper_kafka | 172.28.1.8 | Kafka Zookeeper |
| kafka | 172.28.1.9 | Kafka broker |
| kafka_ui | 172.28.1.10 | Kafka UI |
| zoo1-3 | 172.28.1.11-13 | HBase Zookeeper ensemble |

## Connecting to Services

### Master Node (Hadoop, Spark, Hive, HBase)
```bash
# Access master node shell
docker-compose exec master bash

# Check running Java processes
jps
```

Expected output on master:
```
433 ResourceManager
2209 HMaster
1685 Master
358 SecondaryNameNode
1687 HistoryServer
520 JobHistoryServer
297 NameNode
```

### Worker Nodes
```bash
# Access worker1
docker-compose exec worker1 bash

# Access worker2
docker-compose exec worker2 bash

# Check running processes
jps
```

Expected output on workers:
```
1008 HRegionServer
237 DataNode
303 NodeManager
```

### Kafka
```bash
# Connect to Kafka container
docker exec -it kafka sh

# Kafka scripts are located in /usr/bin or /opt/kafka/bin
# List available commands
ls /usr/bin | grep kafka
```

### PostgreSQL (Additional Server)
```bash
# Connect to PostgreSQL
docker exec -it postgres_server psql -U postgres -d my_postgres_db

# List databases
\l

# List tables
\dt

# Exit
\q
```

### MySQL
```bash
# Connect to MySQL
docker exec -it mysql_server mysql -u root -proot

# Or with admin user
docker exec -it mysql_server mysql -u admin -padmin

# Show databases
SHOW DATABASES;

# Use database
USE my_mysql_db;

# Show tables
SHOW TABLES;

# Exit
EXIT;
```

## Detailed Usage Examples

### 1. Hadoop & YARN

#### Check Cluster Status
```bash
docker-compose exec master bash

# List YARN nodes
yarn node -list
```

Expected output:
```
Total Nodes:2
         Node-Id	     Node-State	Node-Http-Address
   worker1:45019	        RUNNING	     worker1:8042
   worker2:41001	        RUNNING	     worker2:8042
```

#### HDFS Operations
```bash
# Check HDFS status
hdfs dfsadmin -report

# Upload file to HDFS
hadoop fs -put /data/grades.csv /

# List files in HDFS
hadoop fs -ls /

# View file content
hadoop fs -cat /grades.csv

# Download file from HDFS
hadoop fs -get /grades.csv /data/downloaded_grades.csv

# Create directory
hadoop fs -mkdir /mydata

# Remove file
hadoop fs -rm /grades.csv

# Remove directory
hadoop fs -rm -r /mydata
```

#### Verify HDFS Across Nodes
```bash
# From master node
hadoop fs -ls /

# From worker1
docker-compose exec worker1 bash
hadoop fs -ls /

# From worker2
docker-compose exec worker2 bash
hadoop fs -ls /
```

All nodes should see the same files in HDFS.

### 2. Hive

Hive uses Tez as the default execution engine.

#### Connect to Hive
```bash
docker-compose exec master bash
hive
```

#### Create and Query Tables

**Prerequisite**: Upload data file to HDFS
```bash
hadoop fs -put /data/grades.csv /
```

**Create table**:
```sql
CREATE TABLE grades(
    `Last name` STRING,
    `First name` STRING,
    `SSN` STRING,
    `Test1` DOUBLE,
    `Test2` INT,
    `Test3` DOUBLE,
    `Test4` DOUBLE,
    `Final` DOUBLE,
    `Grade` STRING)
COMMENT 'Student grades dataset'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
tblproperties("skip.header.line.count"="1");
```

**Load data**:
```sql
LOAD DATA INPATH '/grades.csv' INTO TABLE grades;
```

**Query data**:
```sql
-- View all records
SELECT * FROM grades;

-- Filter records
SELECT `Last name`, `First name`, `Final`, `Grade` 
FROM grades 
WHERE `Final` > 50;

-- Aggregate data
SELECT `Grade`, COUNT(*) as count 
FROM grades 
GROUP BY `Grade`;
```

Expected output sample:
```
Alfalfa	Aloysius	123-45-6789	40.0	90	100.0	83.0	49.0	D-
Alfred	University	123-12-1234	41.0	97	96.0	97.0	48.0	D+
...
```

**Verify data in HDFS**:
```bash
# Exit Hive (Ctrl+D)
hadoop fs -ls /usr/hive/warehouse/grades
```

**Query from other nodes**:
```bash
docker-compose exec worker2 bash
hive
```
```sql
SELECT * FROM grades;
```

The table is accessible from all nodes.

### 3. Spark

Spark can run in two modes:
1. **YARN mode**: Uses YARN as the cluster manager
2. **Standalone mode**: Uses Spark's built-in cluster manager

#### Run Spark Example (YARN mode)
```bash
docker-compose exec master bash

# Simple example - calculate Pi
run-example SparkPi 10

# Or using spark-submit
spark-submit \
    --class org.apache.spark.examples.SparkPi \
    --master yarn \
    --deploy-mode client \
    --driver-memory 2g \
    --executor-memory 1g \
    --executor-cores 1 \
    $SPARK_HOME/examples/jars/spark-examples*.jar \
    10
```

Expected output:
```
INFO spark.SparkContext: Running Spark version 3.0.0
...
Pi is roughly 3.138915138915139
```

#### Spark Shell (Scala) - YARN mode
```bash
# Connect to Spark shell using YARN
spark-shell --master yarn
```

**Example 1: Count large dataset**
```scala
// Count to 1 billion
spark.range(1000 * 1000 * 1000).count()
// Output: res0: Long = 1000000000
```

**Example 2: Read CSV and query**
```scala
// First, ensure grades.csv is in HDFS
// hadoop fs -put /data/grades.csv /

// Read CSV file
val df = spark.read.format("csv")
    .option("header", "true")
    .load("/grades.csv")

// Show data
df.show()

// Register as temporary view
df.createOrReplaceTempView("df")

// SQL queries
spark.sql("SHOW TABLES").show()
spark.sql("SELECT * FROM df WHERE Final > 50").show()
```

**Example 3: Query Hive tables from Spark**
```scala
// Query existing Hive table
spark.sql("SELECT * FROM grades").show()
```

**Example 4: Understanding Narrow vs Wide Transformations**

This example demonstrates the difference between narrow and wide transformations in Spark:

```scala
// Create a simple list
val data = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

// Create an RDD with 4 partitions
val rdd = sc.parallelize(data, 4)

// Check number of partitions
rdd.getNumPartitions
// Output: res0: Int = 4

// ============================================
// NARROW TRANSFORMATION EXAMPLE (map)
// ============================================
// Each partition is processed independently
// No data shuffle between partitions (fast)
val rddNarrow = rdd.map(x => x * 2)

// Display result
rddNarrow.collect()
// Output: Array[Int] = Array(2, 4, 6, 8, 10, 12, 14, 16, 18, 20)

// ============================================
// WIDE TRANSFORMATION EXAMPLE (groupByKey)
// ============================================
// Data must be redistributed between partitions
// Requires shuffle operation (slower)

// Transform to key-value pairs
// Keys: 0 (even numbers) or 1 (odd numbers)
val rddPair = rdd.map(x => (x % 2, x))

// Group by key (wide transformation - causes shuffle)
val rddWide = rddPair.groupByKey()

// Display result
rddWide.collect()
// Output: Array((0,CompactBuffer(2, 4, 6, 8, 10)), 
//               (1,CompactBuffer(1, 3, 5, 7, 9)))

// ============================================
// VISUALIZE EXECUTION PLAN
// ============================================
// See the difference in execution plans

println(rddNarrow.toDebugString)
// Output: (4) MapPartitionsRDD[2] at map at <console>:...
// → No shuffle stage

println(rddWide.toDebugString)
// Output: ShuffledRDD[5] at groupByKey at <console>:...
// → Contains shuffle stage
```

**Key Differences**:
- **Narrow transformations** (map, filter): Each input partition contributes to only one output partition. No data movement between executors.
- **Wide transformations** (groupByKey, reduceByKey, join): Input partitions contribute to multiple output partitions. Requires shuffle (data exchange across the network).

**Exit Spark shell**:
```scala
:quit
// or press Ctrl+D
```

#### Spark Shell - Standalone mode
```bash
# Connect to Spark shell using standalone cluster
spark-shell --master spark://master:7077
```

Same examples work in standalone mode.

#### PySpark (Python)
```bash
docker-compose exec master bash
pyspark --master yarn
```

```python
# Count large dataset
spark.range(1000 * 1000 * 1000).count()
# Output: 1000000000

# Read CSV
df = spark.read.format('csv').option('header', 'true').load('/grades.csv')
df.show()

# Create temp view and query
df.createOrReplaceTempView('df')
spark.sql('SHOW TABLES').show()
spark.sql('SELECT * FROM df WHERE Final > 50').show()

# Query Hive table
spark.sql('SELECT * FROM grades').show()
```

**Exit PySpark**:
```python
exit()
# or press Ctrl+D
```

#### SparkR (R)
```bash
docker-compose exec master bash
sparkR --master yarn
```

```R
# Create DataFrame
df <- as.DataFrame(list("One", "Two", "Three", "Four"), "This is an example")
head(df)

# Read CSV
df <- read.df("/grades.csv", "csv", header="true")
head(df)
```

**Exit SparkR**:
```R
q()
```

#### Monitor Spark Jobs

While jobs are running, access:
- **Spark Master UI**: http://localhost:8080
- **Active Job UI**: http://localhost:4040 (increments for each job)
- **History Server**: http://localhost:18080

### 4. Flink

Flink supports two deployment modes:

#### Cluster Mode (Flink manages resources)

**Start Flink cluster**:
```bash
docker-compose exec master bash
$FLINK_HOME/bin/start-cluster.sh
```

**Check cluster status**:
```bash
# On master - should show StandaloneSessionClusterEntrypoint
jps

# On workers - should show TaskManagerRunner
docker-compose exec worker1 jps
docker-compose exec worker2 jps
```

**Run WordCount example**:
```bash
# Create input file
echo "hello world hello flink" > /data/input.txt

# Run job
bin/flink run examples/batch/WordCount.jar \
    --input /data/input.txt \
    --output /data/output.txt

# View results
cat /data/output.txt
```

**Stop Flink cluster**:
```bash
$FLINK_HOME/bin/stop-cluster.sh
```

**Access Flink Web UI**: http://localhost:45080

#### YARN Mode

**Option 1: Submit single job** (creates new Flink cluster for each job)
```bash
$FLINK_HOME/bin/flink run -c MainClassName application.jar parameters
```

**Option 2: Start YARN session** (reuse Flink cluster)
```bash
# Start session with 2 TaskManagers (1GB heap each)
$FLINK_HOME/bin/yarn-session.sh -n 2 -jm 1024 -tm 1024 -s 2

# Submit jobs to session
$FLINK_HOME/bin/flink run -c MainClassName application.jar

# Run in background (detached mode)
$FLINK_HOME/bin/yarn-session.sh -n 2 -jm 1024 -tm 1024 -s 2 -d

# Stop YARN session
yarn application -kill <applicationId>
```

Monitor jobs in YARN UI: http://localhost:8088

### 5. HBase

#### Connect to HBase Shell
```bash
docker-compose exec master bash
hbase shell
```

#### Basic Operations

**Check cluster status**:
```ruby
status 'summary'
```

**Create table**:
```ruby
# Create table with column families
create 'tbl_user', 'info', 'detail', 'address'
```

**Insert data** (put command):
```ruby
# Syntax: put 'table', 'rowkey', 'column_family:column', 'value'
put 'tbl_user', 'mengday', 'info:id', '1'
put 'tbl_user', 'mengday', 'info:name', 'John Doe'
put 'tbl_user', 'mengday', 'info:age', '28'
put 'tbl_user', 'mengday', 'address:city', 'New York'
put 'tbl_user', 'mengday', 'address:country', 'USA'
```

**Scan table**:
```ruby
scan 'tbl_user'
```

**Get specific row**:
```ruby
get 'tbl_user', 'mengday'
```

**Get specific column**:
```ruby
get 'tbl_user', 'mengday', 'info:name'
```

**Count rows**:
```ruby
count 'tbl_user'
```

**Delete data**:
```ruby
# Delete specific column
delete 'tbl_user', 'mengday', 'info:age'

# Delete entire row
deleteall 'tbl_user', 'mengday'
```

**Drop table**:
```ruby
# Must disable before dropping
disable 'tbl_user'
drop 'tbl_user'
```

**List tables**:
```ruby
list
```

**Exit HBase shell**:
```ruby
exit
# or press Ctrl+D
```

#### HBase Web UI

Access HBase Master UI: http://localhost:16010

#### HBase Thrift Server

HBase ThriftServer is deployed on **worker2** for programmatic access (Python, Java, etc.).

### 6. Kafka

Kafka scripts are typically located in `/usr/bin` or `/opt/kafka/bin` depending on the Docker image.

#### Connect to Kafka Container
```bash
docker exec -it kafka sh

# Find Kafka scripts
ls /usr/bin | grep kafka
# or
ls /opt/kafka/bin | grep kafka
```

#### Create Topic
```bash
kafka-topics --create \
    --topic test-topic \
    --bootstrap-server localhost:9092 \
    --partitions 1 \
    --replication-factor 1
```

If command not found, use full path:
```bash
/usr/bin/kafka-topics --create \
    --topic test-topic \
    --bootstrap-server localhost:9092 \
    --partitions 1 \
    --replication-factor 1
```

#### List Topics
```bash
kafka-topics --list --bootstrap-server localhost:9092
```

Expected output:
```
test-topic
```

#### Produce Messages (Send data to topic)

**Terminal 1 - Producer**:
```bash
docker exec -it kafka sh

kafka-console-producer \
    --broker-list localhost:9092 \
    --topic test-topic
```

Type messages (each line is a message):
```
hello kafka
this is a test
message 123
```

Press `Ctrl + C` to exit producer.

#### Consume Messages (Read from topic)

**Terminal 2 - Consumer**:
```bash
docker exec -it kafka sh

kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --topic test-topic \
    --from-beginning
```

Expected output:
```
hello kafka
this is a test
message 123
```

Press `Ctrl + C` to exit consumer.

#### Describe Topic
```bash
kafka-topics --describe \
    --topic test-topic \
    --bootstrap-server localhost:9092
```

#### Delete Topic
```bash
kafka-topics --delete \
    --topic test-topic \
    --bootstrap-server localhost:9092
```

#### Create Topic with Multiple Partitions
```bash
kafka-topics --create \
    --topic multi-partition-topic \
    --bootstrap-server localhost:9092 \
    --partitions 3 \
    --replication-factor 1
```

#### Consumer Groups
```bash
# List consumer groups
kafka-consumer-groups --list \
    --bootstrap-server localhost:9092

# Describe consumer group
kafka-consumer-groups --describe \
    --group my-group \
    --bootstrap-server localhost:9092
```

#### Kafka Web UI

Access Kafka UI for easier management: http://localhost:8090

From the UI you can:
- View topics and partitions
- Monitor consumer groups
- View messages
- Create/delete topics
- Monitor cluster health

### 7. Sqoop

Sqoop enables data transfer between relational databases and Hadoop.

#### List Databases
```bash
docker-compose exec master bash

# List PostgreSQL databases
sqoop list-databases \
    --connect jdbc:postgresql://hivemetastore:5432/pgdata \
    --username pguser \
    --password 123456
```

#### List Tables
```bash
sqoop list-tables \
    --connect jdbc:postgresql://hivemetastore:5432/pgdata \
    --username pguser \
    --password 123456 \
    -- --schema "pguser_public"
```

**Note**: `--schema` must be placed after `--` to work correctly.

#### Execute SQL Query
```bash
sqoop eval \
    --connect jdbc:postgresql://hivemetastore:5432/pgdata \
    --username pguser \
    --password 123456 \
    --query "SELECT * FROM pguser_public.course"
```

#### Import from Database to HDFS

**Important flags**:
- `-Dorg.apache.sqoop.splitter.allow_text_splitter=true`: Allows splitting on text columns
- `--schema`: Must be placed after `--` separator
- `--null-string` and `--null-non-string`: Handle NULL values (requires `standard_conforming_strings = on` in PostgreSQL)

```bash
sqoop import \
    -Dorg.apache.sqoop.splitter.allow_text_splitter=true \
    --connect jdbc:postgresql://hivemetastore:5432/pgdata \
    --username pguser \
    --password 123456 \
    --table course \
    --target-dir /course_export \
    --delete-target-dir \
    --fields-terminated-by '\t' \
    --lines-terminated-by '\n' \
    --split-by cid \
    -- --schema pguser_public
```

**Verify import**:
```bash
# List files
hdfs dfs -ls /course_export

# View content
hdfs dfs -cat /course_export/*
```

#### Import from Database to Hive

**Option 1**: Import to existing Hive table
```bash
# First create table in Hive
hive
```
```sql
CREATE EXTERNAL TABLE course_hive(
    cid STRING,
    cname STRING,
    tid STRING)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';
```
```bash
exit
```

**Option 2**: Auto-create Hive table (recommended)
```bash
sqoop import \
    -Dorg.apache.sqoop.splitter.allow_text_splitter=true \
    --connect jdbc:postgresql://hivemetastore:5432/pgdata \
    --username pguser \
    --password 123456 \
    --table course \
    --fields-terminated-by '\t' \
    --lines-terminated-by '\n' \
    --hive-import \
    --hive-table course_hive \
    --hive-overwrite \
    --split-by cid \
    -- --schema pguser_public
```

**Verify in Hive**:
```bash
hive
```
```sql
SELECT * FROM course_hive;
```

Expected output:
```
01      语文    02
02      数学    01
03      英语    03
Time taken: 4.71 seconds, Fetched: 3 row(s)
```

#### Handle NULL Values
```bash
sqoop import \
    -Dorg.apache.sqoop.splitter.allow_text_splitter=true \
    --connect jdbc:postgresql://hivemetastore:5432/pgdata \
    --username pguser \
    --password 123456 \
    --table course \
    --target-dir /course_export \
    --null-string '\\N' \
    --null-non-string '\\N' \
    -- --schema pguser_public
```

### 8. Hudi

Hudi (Hadoop Upserts Deletes and Incrementals) enables record-level insert, update, and delete operations on data lakes.

**Important Notes**:
- Hudi JARs must be compiled according to your Hadoop/Spark/Flink versions
- The JARs are already included in `$SPARK_HOME/jars/`
- Hudi deploys with no long-running servers (no additional infrastructure cost)

#### Start Spark Shell with Hudi
```bash
docker-compose exec master bash

spark-shell \
    --conf 'spark.serializer=org.apache.spark.serializer.KryoSerializer'
```

**Note**: `--jars` is not needed as Hudi JARs are auto-discovered in `$SPARK_HOME/jars/`.


### Hudi Example: Insert Data

```scala
import org.apache.hudi.QuickstartUtils._
import scala.collection.JavaConversions._
import org.apache.spark.sql.SaveMode._
import org.apache.hudi.DataSourceReadOptions._
import org.apache.hudi.DataSourceWriteOptions._
import org.apache.hudi.config.HoodieWriteConfig._

// Define table configuration
val tableName = "hudi_trips_cow"
// Must use HDFS path (not local file://)
// WARN: Timeline-server-based markers are not supported for HDFS
val basePath = "hdfs://master:9000/tmp/hudi_trips_cow"
val dataGen = new DataGenerator

// Generate and insert 10 sample records
val inserts = convertToStringList(dataGen.generateInserts(10))
val df = spark.read.json(spark.sparkContext.parallelize(inserts, 2))

// Display data before writing
df.show()

// Write to Hudi table (Copy-On-Write format)
df.write.format("hudi").
    options(getQuickstartWriteConfigs).
    option(PRECOMBINE_FIELD_OPT_KEY, "ts").
    option(RECORDKEY_FIELD_OPT_KEY, "uuid").
    option(PARTITIONPATH_FIELD_OPT_KEY, "partitionpath").
    option(TABLE_NAME, tableName).
    mode(Overwrite).
    save(basePath)
```

**Explanation**:
- **PRECOMBINE_FIELD_OPT_KEY**: Field used to determine which record is most recent (timestamp)
- **RECORDKEY_FIELD_OPT_KEY**: Unique identifier for each record (uuid)
- **PARTITIONPATH_FIELD_OPT_KEY**: Field used for partitioning data
- **TABLE_NAME**: Hudi table name
- **mode(Overwrite)**: Creates new table or overwrites existing one

### Hudi Example: Query Data

```scala
// Read Hudi table as Snapshot
val tripsSnapshotDF = spark.
    read.
    format("hudi").
    load(basePath)

// Register as temporary view for SQL queries
tripsSnapshotDF.createOrReplaceTempView("hudi_trips_snapshot")

// Query 1: Filter by fare amount
spark.sql("SELECT fare, begin_lon, begin_lat, ts FROM hudi_trips_snapshot WHERE fare > 20.0").show()

// Query 2: Show Hudi metadata columns
spark.sql("SELECT _hoodie_commit_time, _hoodie_record_key, _hoodie_partition_path, rider, driver, fare FROM hudi_trips_snapshot").show()
```

**Expected Output**:
```
+----+----------+---------+-------------+
|fare|begin_lon |begin_lat|ts           |
+----+----------+---------+-------------+
|27.7|0.6273212 |0.116777 |1695091554788|
|33.9|0.9694586 |0.1856488|1695091554788|
...
+----+----------+---------+-------------+

+--------------------+--------------------+----------------------+------+------+----+
|_hoodie_commit_time|_hoodie_record_key  |_hoodie_partition_path|rider |driver|fare|
+--------------------+--------------------+----------------------+------+------+----+
|20231027104532      |uuid1               |americas/brazil/sao...|rider1|drv1  |19.1|
...
+--------------------+--------------------+----------------------+------+------+----+
```

### Hudi Example: Update Data

Hudi supports record-level updates - a key feature for data lakes.

```scala
// Generate updates for 10 existing records
val updates = convertToStringList(dataGen.generateUpdates(10))
val df = spark.read.json(spark.sparkContext.parallelize(updates, 2))

// Display updates
df.show()

// Write updates to Hudi table
df.write.format("hudi").
    options(getQuickstartWriteConfigs).
    option(PRECOMBINE_FIELD_OPT_KEY, "ts").
    option(RECORDKEY_FIELD_OPT_KEY, "uuid").
    option(PARTITIONPATH_FIELD_OPT_KEY, "partitionpath").
    option(TABLE_NAME, tableName).
    mode(Append).  // Use Append mode for updates
    save(basePath)
```

**Verify Updates**:
```scala
// Re-read the table
val tripsSnapshotDF = spark.read.format("hudi").load(basePath)
tripsSnapshotDF.createOrReplaceTempView("hudi_trips_snapshot")

// Query again - compare with previous results
spark.sql("SELECT fare, begin_lon, begin_lat, ts FROM hudi_trips_snapshot WHERE fare > 20.0").show()

// Check commit times to see updates
spark.sql("SELECT _hoodie_commit_time, _hoodie_record_key, rider, driver, fare FROM hudi_trips_snapshot").show()
```

You should notice:
- Updated records have newer `_hoodie_commit_time` values
- Data values have changed for updated records
- Record keys remain the same

### Hudi Example: Time Travel Queries

Hudi allows you to query data as it existed at a specific point in time.

```scala
// Query as of specific commit time
val commits = spark.sql("SELECT DISTINCT(_hoodie_commit_time) FROM hudi_trips_snapshot ORDER BY _hoodie_commit_time").collect()

// Get first commit time
val firstCommit = commits(0)(0).toString

// Read data as of first commit (before updates)
val firstCommitDF = spark.read.
    format("hudi").
    option("as.of.instant", firstCommit).
    load(basePath)

firstCommitDF.createOrReplaceTempView("hudi_trips_first_commit")
spark.sql("SELECT fare, begin_lon, begin_lat, ts FROM hudi_trips_first_commit WHERE fare > 20.0").show()
```

### Hudi Example: Incremental Queries

Query only the data that changed between two commits.

```scala
// Get commit times
val commits = spark.sql("SELECT DISTINCT(_hoodie_commit_time) FROM hudi_trips_snapshot ORDER BY _hoodie_commit_time").map(_.getString(0)).collect()

// Read incremental changes between first and last commit
val incrementalDF = spark.read.
    format("hudi").
    option(QUERY_TYPE_OPT_KEY, QUERY_TYPE_INCREMENTAL_OPT_VAL).
    option(BEGIN_INSTANTTIME_OPT_KEY, commits(0)).
    option(END_INSTANTTIME_OPT_KEY, commits(commits.length - 1)).
    load(basePath)

incrementalDF.show()
```

### Hudi: Verify in HDFS

```bash
# Exit spark-shell (Ctrl+D)

# Check Hudi table structure in HDFS
hadoop fs -ls /tmp/hudi_trips_cow

# View partition structure
hadoop fs -ls /tmp/hudi_trips_cow/*

# View metadata
hadoop fs -ls /tmp/hudi_trips_cow/.hoodie
```

Expected structure:
```
/tmp/hudi_trips_cow/
├── .hoodie/                    (Hudi metadata)
│   ├── commits/
│   ├── metadata/
│   └── ...
└── americas/                   (Partitions)
    ├── brazil/
    │   └── sao_paulo/
    └── united_states/
        └── san_francisco/
```

### Hudi: Key Concepts

**Table Types**:
1. **Copy-On-Write (COW)**: Update entire file when records change. Fast reads, slower writes.
2. **Merge-On-Read (MOR)**: Append updates to delta logs. Fast writes, slower reads.

**Query Types**:
1. **Snapshot**: Latest view of data
2. **Incremental**: Changes between two points in time
3. **Read Optimized**: For MOR tables, reads only base files (faster but not latest)

**Metadata Columns** (automatically added by Hudi):
- `_hoodie_commit_time`: Commit timestamp
- `_hoodie_record_key`: Unique record identifier
- `_hoodie_partition_path`: Partition path
- `_hoodie_file_name`: Parquet file name

## 9. Zeppelin

Zeppelin provides an interactive notebook interface for data analysis and visualization.

### Access Zeppelin

Open your browser: **http://localhost:8890**

### Zeppelin Features

- **Multi-language support**: Spark (Scala, Python, R), Hive, Shell, Markdown
- **Data visualization**: Built-in charts and graphs
- **Collaborative**: Share notebooks with team
- **Integration**: Works with Spark, Hive, HBase, Flink

### Test Zeppelin

A test notebook is included in the `zeppelin_notebooks/` directory.

#### Test 1: Shell Commands

Create a new note or paragraph with `%sh` interpreter:

```bash
%sh
echo "Hello from Zeppelin!"
hostname
date
```

#### Test 2: Spark (Scala)

```scala
%spark
// Create RDD
val data = sc.parallelize(1 to 100)

// Calculate sum
val sum = data.reduce(_ + _)
println(s"Sum: $sum")

// Show first 10 elements
data.take(10)
```

#### Test 3: PySpark (Python)

```python
%pyspark
# Read data
df = spark.read.format('csv').option('header', 'true').load('/data/grades.csv')

# Show data
df.show(5)

# Register as temp view
df.createOrReplaceTempView('grades')

# SQL query
result = spark.sql("SELECT Grade, COUNT(*) as count FROM grades GROUP BY Grade")
result.show()
```

#### Test 4: Hive

```sql
%hive
SHOW DATABASES;

USE default;
SHOW TABLES;

SELECT * FROM grades LIMIT 10;
```

#### Test 5: SparkSQL

```sql
%sql
SELECT `Grade`, COUNT(*) as student_count, AVG(`Final`) as avg_final
FROM grades
GROUP BY `Grade`
ORDER BY student_count DESC
```

#### Test 6: Data Visualization

Zeppelin automatically detects data and offers visualization options:

```sql
%sql
SELECT `Grade`, AVG(`Test1`) as avg_test1, AVG(`Test2`) as avg_test2, 
       AVG(`Test3`) as avg_test3, AVG(`Test4`) as avg_test4
FROM grades
GROUP BY `Grade`
```

After running, click on the chart icons to switch between:
- **Table**: Raw data
- **Bar Chart**: Compare grades
- **Pie Chart**: Distribution
- **Line Chart**: Trends
- **Scatter Plot**: Correlations

#### Test 7: Markdown Documentation

```markdown
%md
# My Data Analysis

## Dataset: Student Grades

This notebook analyzes student performance across multiple tests.

### Key Findings:
- Average final score: 45.5
- Pass rate: 62%
- Most common grade: B

**Next Steps**:
1. Analyze correlation between tests
2. Identify struggling students
3. Recommend interventions
```

### Zeppelin Configuration

#### Add Interpreters

Go to **Settings (⚙️) → Interpreter**

Available interpreters:
- **%spark**: Spark (Scala)
- **%pyspark**: PySpark (Python)
- **%sparkr**: SparkR (R)
- **%sql**: SparkSQL
- **%hive**: Hive
- **%sh**: Shell commands
- **%md**: Markdown

#### Notebook Shortcuts

- **Shift + Enter**: Run paragraph
- **Ctrl + Alt + N**: New paragraph below
- **Ctrl + Alt + M**: Toggle Markdown/Code
- **Ctrl + Alt + D**: Delete paragraph

### Persistent Storage

All notebooks are saved in `./zeppelin_notebooks/` on the host machine. They persist across container restarts.

```bash
# View saved notebooks
ls -la zeppelin_notebooks/
```

## 10. Monitoring & Logs

### Check Service Status

#### Quick Health Check

```bash
# Check all containers
docker-compose ps

# Should show all services as "Up"
```

#### Detailed Status

```bash
# Check YARN nodes
docker-compose exec master yarn node -list

# Check HDFS status
docker-compose exec master hdfs dfsadmin -report

# Check HBase status
docker-compose exec master bash -c "echo 'status \"summary\"' | hbase shell"
```

#### Java Process Status

```bash
# Master node
docker-compose exec master jps

# Expected processes:
# - NameNode
# - ResourceManager
# - SecondaryNameNode
# - Master (Spark)
# - HMaster (HBase)
# - HistoryServer
# - JobHistoryServer

# Worker nodes
docker-compose exec worker1 jps
docker-compose exec worker2 jps

# Expected processes:
# - DataNode
# - NodeManager
# - Worker (Spark)
# - HRegionServer (HBase)
```

### View Logs

#### Real-time Logs (Docker)

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f master
docker-compose logs -f worker1
docker-compose logs -f kafka
docker-compose logs -f postgres_server

# Search logs
docker-compose logs -f | grep ERROR
docker-compose logs -f | grep WARN
docker-compose logs -f master | grep "Started"
```

#### Log Files (Local Directory)

Logs are synchronized to `./logs/` directory:

```bash
# View log structure
tree ./logs/

# Output:
# ./logs/
# ├── hadoop/
# │   ├── hadoop-root-namenode-master.log
# │   ├── hadoop-root-datanode-worker1.log
# │   └── ...
# ├── hbase/
# │   ├── hbase-root-master-master.log
# │   └── ...
# ├── hive/
# │   └── hive.log
# ├── spark/
# │   ├── spark-root-master-master.out
# │   └── ...
# ├── flink/
# │   └── flink-root-taskmanager.log
# └── zeppelin/
#     └── zeppelin-interpreter.log
```

#### View Specific Logs

```bash
# Hadoop NameNode log
tail -f ./logs/hadoop/hadoop-root-namenode-master.log

# Spark Master log
tail -f ./logs/spark/spark-root-master-master.out

# HBase Master log
tail -f ./logs/hbase/hbase-root-master-master.log

# Hive log
tail -f ./logs/hive/hive.log

# Search for errors
grep -r "ERROR" ./logs/hadoop/
grep -r "Exception" ./logs/spark/
```

### Performance Monitoring

#### YARN Resource Usage

Access YARN UI: **http://localhost:8088**

View:
- Running applications
- Memory usage per node
- CPU usage
- Queue statistics
- Application history

#### Spark Monitoring

1. **Master UI** (http://localhost:8080):
   - Worker status
   - Running applications
   - Completed applications
   - Resource allocation

2. **Worker UIs**:
   - http://localhost:8981 (worker1)
   - http://localhost:8982 (worker2)

3. **History Server** (http://localhost:18080):
   - All completed Spark jobs
   - Execution timeline
   - Stage details
   - Task metrics

4. **Active Job UI** (http://localhost:4040):
   - Real-time job progress
   - DAG visualization
   - Stage metrics
   - Executor details

#### HDFS Storage

Access NameNode UI: **http://localhost:9870**

View:
- DataNode status
- Storage capacity
- Block information
- File browser

```bash
# Command line
hadoop fs -df -h
hadoop fs -du -h /
```

#### HBase Monitoring

Access HBase Master UI: **http://localhost:16010**

View:
- RegionServer status
- Table information
- Region distribution
- Requests per second

#### Kafka Monitoring "akhq"

Access Kafka UI: **http://localhost:8090**

View:
- Topics and partitions
- Consumer groups
- Broker status
- Message throughput
- Consumer lag

### Troubleshooting

#### Container Won't Start

```bash
# Check logs for specific service
docker-compose logs hivemetastore
docker-compose logs master

# Check if port is already in use
netstat -tuln | grep 8080
netstat -tuln | grep 9092

# Recreate specific service
docker-compose up -d --force-recreate master
```

#### Out of Memory Errors

```bash
# Check Docker resources
docker stats

# Increase Docker memory (Docker Desktop)
# Settings → Resources → Memory → 8GB minimum

# Check YARN memory allocation
docker-compose exec master bash
yarn node -list -showDetails
```

#### YARN Reports Unhealthy Nodes

```bash
# Check disk space (must be > 90% free)
df -h

# Clean up Docker
docker system prune -a

# Check YARN node health
docker-compose exec master yarn node -list -all
```

#### Spark Job Fails

```bash
# Check Spark logs
docker-compose logs master | grep spark

# Check executor logs in YARN UI
# http://localhost:8088 → Application → Logs

# View Spark History
# http://localhost:18080

# Check available resources
docker-compose exec master yarn node -list
```

#### HBase Connection Issues

```bash
# Check Zookeeper status
docker-compose exec zoo1 bash
zkServer.sh status

# Check HBase status
docker-compose exec master bash
hbase shell
status 'detailed'

# Restart HBase services
docker-compose restart master worker1 worker2
```

#### Kafka Connection Issues

```bash
# Check if Kafka is running
docker exec -it kafka sh
ps aux | grep kafka

# Test Kafka connectivity
kafka-broker-api-versions --bootstrap-server localhost:9092

# Check Zookeeper connection
echo stat | nc localhost 21810

# Restart Kafka
docker-compose restart kafka zookeeper_kafka
```

#### Database Connection Issues

**PostgreSQL**:
```bash
# Test connection
docker exec -it postgres_server psql -U postgres -d my_postgres_db -c "SELECT 1;"

# Check logs
docker-compose logs postgres_server

# Restart
docker-compose restart postgres_server
```

**MySQL**:
```bash
# Test connection
docker exec -it mysql_server mysql -u root -proot -e "SELECT 1;"

# Check logs
docker-compose logs mysql_server

# Restart
docker-compose restart mysql_server
```

### Cleanup Operations

#### Remove Specific Data

```bash
# Clean HDFS directory
hadoop fs -rm -r /tmp/*

# Clean Hive tables
hive -e "DROP TABLE IF EXISTS grades;"

# Clean HBase table
echo "disable 'tbl_user'; drop 'tbl_user'" | hbase shell

# Delete Kafka topic
kafka-topics --delete --topic test-topic --bootstrap-server localhost:9092
```

#### Reset Entire Cluster

```bash
# Stop all services
docker-compose stop

# Remove all containers (data volumes preserved)
docker-compose down

# Remove all data (CAUTION: This deletes everything!)
rm -rf ./logs/* ./data/* ./zeppelin_notebooks/* ./postgres_data/* ./mysql_data/*

# Start fresh
docker-compose up -d
```

## 11. Best Practices

### Data Management

1. **Use HDFS for large datasets**: Store data in `/data/` directory and upload to HDFS
2. **Partition tables**: Use partitioning in Hive and Hudi for better performance
3. **Regular cleanup**: Remove temporary files and old data
4. **Backup important data**: Copy data from containers to host regularly

### Performance Optimization

1. **Allocate sufficient memory**: Minimum 8GB for Docker
2. **Monitor resource usage**: Use YARN and Spark UIs
3. **Use appropriate file formats**: Parquet for analytics, Avro for streaming
4. **Tune Spark configurations**: Adjust executor memory and cores
5. **Optimize Hive queries**: Use partitioning and bucketing

### Security Considerations

⚠️ **This setup is for development/testing only!**

- Default passwords are used (not secure)
- No authentication/authorization configured
- All services exposed on localhost
- No encryption enabled

For production use:
- Change all default passwords
- Enable Kerberos authentication
- Use SSL/TLS for communications
- Implement proper access controls
- Use dedicated security tools (Ranger, Knox)

## 12. Quick Reference

### Essential Commands

```bash
# Start platform
docker-compose up -d

# Stop platform
docker-compose stop

# View logs
docker-compose logs -f

# Access master node
docker-compose exec master bash

# Check services
docker-compose ps
docker-compose exec master jps

# HDFS operations
hadoop fs -ls /
hadoop fs -put file.csv /
hadoop fs -cat /file.csv

# Hive
hive -e "SHOW TABLES;"

# Spark submit
spark-submit --master yarn --class MainClass app.jar

# HBase shell
echo "list" | hbase shell

# Kafka topic
kafka-topics --list --bootstrap-server localhost:9092
```

### All Service URLs

| Service | URL |
|---------|-----|
| YARN ResourceManager | http://localhost:8088 |
| Hadoop NameNode | http://localhost:9870 |
| Spark Master | http://localhost:8080 |
| Spark History | http://localhost:18080 |
| HBase Master | http://localhost:16010 |
| Flink | http://localhost:45080 |
| Zeppelin | http://localhost:8890 |
| Kafka UI | http://localhost:8090 |

### All Credentials

| Service | User | Password | Port | Database |
|---------|------|----------|------|----------|
| PostgreSQL (Metastore) | postgres | new_password | 5432 | - |
| PostgreSQL (Server) | postgres | root | 5439 | my_postgres_db |
| MySQL | root | root | 3307 | my_mysql_db |
| MySQL | admin | admin | 3307 | my_mysql_db |
| Hive JDBC | - | - | 10000 | - |

---

**Author:** Seifeddine Abdelhak

For issues or questions, please open an issue in the repository.