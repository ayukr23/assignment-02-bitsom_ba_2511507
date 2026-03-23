## Storage Systems

This section explains which database or storage system was chosen for each of the four hospital goals and why.

**Goal 1 — Predict patient readmission risk** requires a Machine Learning pipeline trained on historical treatment data: past admissions, diagnoses (ICD codes), medications, lab results, and discharge summaries. The chosen storage system is a **Data Lakehouse (Delta Lake on S3 or Azure Data Lake Storage)**. A lakehouse is the right choice because the training data is heterogeneous — structured lab values, semi-structured EHR records, and unstructured clinical notes all coexist. Delta Lake provides ACID transactions, schema evolution, and time-travel versioning, which means the ML team can always reproduce a historical training dataset even after new records arrive. Apache Spark reads directly from the lakehouse to build features and train an XGBoost or LightGBM readmission model.

**Goal 2 — Allow doctors to query patient history in plain English** requires semantic search over patient records. The chosen system is a **Vector Database (Pinecone or Weaviate)**. Each patient's clinical history is chunked into paragraphs, encoded into 384-dimensional embeddings using a sentence-transformer model, and stored as dense vectors. When a doctor asks *"Has this patient had a cardiac event before?"*, the query is encoded and the vector database performs Approximate Nearest Neighbour (ANN) search to retrieve the most semantically relevant clinical notes. These retrieved passages are then fed into a Retrieval-Augmented Generation (RAG) pipeline with a large language model to produce a plain-English answer.

**Goal 3 — Generate monthly reports for hospital management** requires reliable aggregated analytics on bed occupancy, department-wise costs, and readmission rates. The chosen system is a **Data Warehouse (Amazon Redshift or Google BigQuery)** with a star schema: a central `fact_admissions` table joined to `dim_date`, `dim_department`, `dim_ward`, and `dim_patient`. Redshift's columnar storage and massively parallel processing make month-over-month GROUP BY queries extremely fast, and tools like Power BI or Looker connect directly to generate PDF and Excel management reports.

**Goal 4 — Stream and store real-time vitals from ICU monitoring devices** requires a low-latency streaming pipeline. The chosen system is **Apache Kafka** as the message broker (producing ICU events in real time) combined with **Apache Flink** for stream processing (threshold alerting and anomaly detection). The processed events are also written to a time-series-optimised store such as **InfluxDB** or the lakehouse for historical analysis. Kafka provides durable, ordered, replay-capable storage of vitals streams with retention policies.

---

## OLTP vs OLAP Boundary

The transactional system ends and the analytical system begins at the **ETL / CDC boundary** between PostgreSQL and the downstream analytical layers.

**OLTP side** (PostgreSQL): All real-time operational transactions — patient admissions, medication orders, billing entries, appointment bookings are written to PostgreSQL. This is the system of record. It is ACID-compliant, row-oriented, and optimised for high-throughput individual row reads and writes. The OLTP layer must never be queried by heavy analytical workloads, as doing so would degrade clinical response times.

**OLAP side** (Redshift, Delta Lake): Change Data Capture (Debezium) continuously replicates new and updated rows from PostgreSQL into the analytical layer without impacting OLTP performance. Nightly Airflow batch jobs additionally push lab results and historical data into the lakehouse. Once data crosses into Redshift or Delta Lake, it is transformed into denormalised star schemas optimised for analytical GROUP BY, window functions, and aggregation queries are operations that would be inefficient in a normalised OLTP database.

The **REST API Gateway** forms a parallel boundary for the NLP use case: doctor queries never touch PostgreSQL directly; they are routed to the vector database, keeping OLTP load isolated.

---

## Trade-offs

**The primary trade-off in this architecture is complexity versus capability.**

Deploying five distinct storage systems — PostgreSQL, Kafka, Delta Lake, Redshift, and Pinecone — alongside orchestration tools (Airflow, Debezium, Flink) and an ML/RAG pipeline creates significant operational overhead. Each system has its own monitoring, scaling, backup, and security requirements. A small hospital IT team may struggle to operate this stack reliably, and failures in the CDC pipeline or the Kafka cluster could cause data inconsistencies across the analytical layer without the clinical staff noticing immediately.

**Mitigation strategy:** The hospital should adopt a **managed cloud-native stack** to reduce operational burden. For example, using **Azure Health Data Services** (which bundles FHIR-compliant OLTP, streaming, and analytics in one governed platform) or **AWS HealthLake** significantly reduces the number of independently managed services. Additionally, implementing **data quality monitors** (using Great Expectations or dbt tests) at every ingestion boundary ensures that failures are caught at the source rather than silently propagating into the ML model or monthly reports. A phased rollout — starting with Goals 3 and 4 (reporting and streaming) before adding the ML and vector search layers — reduces the risk of simultaneous multi-system failures during initial deployment.
