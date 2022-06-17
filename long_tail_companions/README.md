# Getting Started with DataHub

This repo provides a step-by-step tutorial to demonstrate how to ingest metadata into DataHub from a variety of commonly-used data tools.

## Example: Long Tail Companions

Long Tail Companions is a fictional pet adoption and pet supplies company with a complex, fragmented data stack across four different teams:

**Adoptions Team:** focused on building applications to match adoptable pets with new homes.
* Data Stack: Postgres for transactional records and MongoDB for pet/human applications

**E-Commerce Team:** focused on building an ecommerce store to sell pet supplies.
* Data Stack: Postgres for transactional records and Kafka for click-stream user analytics

**Data Platform Team:** tasked with syncing all data into a central data lake & mantaining a central data platform to support Analytics and Data Science use cases.
* Data Stack: Airflow for workflow orchestration, S3 as datalake, Spark for complex data processing, and Snowflake as analytical warehouse

**Analytics Engineering Team:** responsible for buidling scalable analytical resources
* Data Stack: dbt for transformations, Great Expecatations for data quality, and Looker for surfacing resources to stakeholders

![](imgs/long_tail_data_stack.png)