## Anomaly Analysis

## Insert Anomaly
Definition: An insert anomaly occurs when a new record cannot be added to the database without also inserting unrelated or dummy data.
Example from dataset:

-- The dataset contains 8 products (P001–P008), but a new product for example, a "Projector" cannot be added to the system unless it is tied to an actual order.
-- The columns product_id, product_name, category, and unit_price only exist as part of an order row. There is no independent product table.
-- Affected columns: product_id, product_name, category, unit_price
-- Specific impact: If the company stocks a new product before any customer orders it, there is no way to record it in this flat-file structure without creating a fake order row.


## Update Anomaly
Definition: An update anomaly occurs when a single real-world change requires updating multiple rows, and missing even one creates inconsistency.
Example from dataset:

-- Sales Representative SR01 - Deepak Joshi has the office_address column populated across many order rows.
-- In most rows it is stored as: Mumbai HQ, Nariman Point, Mumbai - 400021
-- However, in rows such as ORD1180, ORD1173, ORD1174, ORD1175, ORD1176, ORD1177, ORD1178, ORD1179 and others, the address is abbreviated as: Mumbai HQ, Nariman Pt, Mumbai - 400021
-- This is the same office address stored inconsistently across rows for the same sales rep due to partial updates.
-- Affected column: office_address
-- Affected rows: ORD1180, ORD1173, ORD1174, ORD1175, ORD1176, ORD1177, ORD1178, ORD1179, ORD1181, ORD1182, ORD1183, ORD1184
-- Impact: Any update to SR01's office address must be applied to every single order row he is linked to. Inconsistency already exists in the dataset as proof.


## Delete Anomaly
Definition: A delete anomaly occurs when deleting a record unintentionally destroys other important information.
Example from dataset:

-- Product P008 - Webcam (Electronics, ₹2100) appears in only one order: ORD1185 (placed by customer C003 - Amit Verma on 2023-06-15).
-- If order ORD1185 is deleted for example because the order was cancelled or returned — all knowledge of the Webcam product is permanently lost from the system.
-- Affected row: ORD1185
-- Affected columns: product_id, product_name, category, unit_price
-- Impact: The company loses the product catalogue entry for Webcam simply by cancelling one order. In a normalized schema, the Products table would retain this record independently.


## Normalization Justification
The manager argues that keeping everything in one table is simpler and that normalization is over-engineering. Using specific examples from the orders_flat.csv dataset, here is a defense of normalization to Third Normal Form (3NF).
At first glance, a single flat table like orders_flat.csv appears convenient all data is in one place, and simple queries require no JOIN operations. However, the dataset itself provides clear evidence that this apparent simplicity is a liability, not an asset.
The most glaring proof is the office_address column for Sales Representative SR01 - Deepak Joshi. His address appears across dozens of order rows and is already stored inconsistently, some rows say "Nariman Point" while others say "Nariman Pt." This happened because updating an address in a flat file means updating every single row linked to that person. Missing even one row creates a contradiction in the data. In a normalized SalesReps table, there is exactly one row for SR01. Updating his address is a single operation, and consistency is guaranteed by design.
Similarly, consider product P008 - Webcam. It appears in exactly one order row (ORD1185). If that order is deleted, a perfectly routine business event for a return or cancellation — the Webcam disappears from the system entirely. The company would have no record that this product exists or what it costs. A normalized Products table stores product data independently of orders, so cancellations never destroy the product catalogue.
The insert anomaly is equally problematic. Imagine the company signs a supplier contract for a new product a Projector before any customer places an order. In the flat file, there is no way to record this product without fabricating a dummy order. This is not a theoretical concern; it reflects a real constraint that would block routine business operations.
Normalization into Customers, Products, SalesReps, and Orders tables resolves all three anomaly classes cleanly. Yes, queries require JOINs but any modern database engine handles JOINs efficiently, and the trade-off is a system where data is trustworthy, updates are atomic, and deletions are safe. Normalization is not over-engineering; it is the minimum standard for a reliable retail database.
