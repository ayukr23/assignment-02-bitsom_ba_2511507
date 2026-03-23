## Architecture Recommendation

For a fast-growing food delivery startup collecting GPS location logs, customer text reviews, payment transactions, and restaurant menu images, the recommended architecture is a **Data Lakehouse**.

### Why Not a Data Warehouse?

A traditional data warehouse such as Redshift or BigQuery is purpose-built for structured, tabular data and predefined analytical schemas. It would handle payment transactions well, but GPS logs are semi-structured time-series data, customer text reviews are unstructured free text, and restaurant menu images are binary files. Loading these diverse formats into a rigid warehouse schema requires heavy upfront ETL transformation, and any change in data format such as a new GPS field or image dimension requires expensive schema migrations. The warehouse would be the right tool for the payment transactions component alone, but it fails to accommodate the full diversity of this startup's data.

### Why Not a Plain Data Lake?

A plain data lake such as S3 or HDFS stores all raw formats cheaply and without schema constraints. However, it provides no query governance, no ACID transactions, and no standard SQL interface. Analysts cannot directly query GPS logs alongside payment records without writing complex Spark jobs. There is no versioning, no data quality enforcement, and no protection against partial writes corrupting a dataset. As the startup scales, the lake becomes a "data swamp" which is difficult to govern, audit, or trust.

### Why a Data Lakehouse?

A Data Lakehouse (e.g., **Delta Lake on Databricks**, **Apache Iceberg on AWS**, or **Microsoft Fabric**) combines the low-cost, format-flexible storage of a data lake with the governance, ACID compliance, and SQL queryability of a warehouse. Three specific reasons make it the right choice here:

**Reason 1 — Multi-format support:** GPS logs (JSON/Parquet), reviews (text), transactions (structured CSV), and images (binary blobs) can all be stored in their native formats in the same storage layer. DuckDB or Spark can query across formats in a single pipeline, exactly as demonstrated in this assignment's Part 5 queries.

**Reason 2 — Real-time and batch in one layer:** Food delivery is latency-sensitive. The lakehouse supports both streaming ingestion of live GPS pings and batch processing of daily payment reconciliation reports using the same storage layer, eliminating the need for separate Lambda architecture pipelines.

**Reason 3 — Scalable ML and analytics:** Customer reviews and menu images are inputs for NLP sentiment models and image recognition systems. A lakehouse keeps raw training data, processed features, and analytical tables co-located, enabling data scientists and analysts to work from the same platform without data duplication or pipeline divergence.
