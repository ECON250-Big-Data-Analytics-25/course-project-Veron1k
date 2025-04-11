{{
config(
materialized = 'incremental',
incremental_strategy='merge',
unique_key = 'title'
       )
}}


select
    title,
    min(DATE(datehour)) as min_date,
    max(DATE(datehour)) as max_date,
    sum(views) as total_views
from {{ source('test_dataset', 'assignment5_input') }}




{% if is_incremental() %}
where DATE(datehour) >= (select max(max_date) from {{ this }}) - 1
{% endif %}
 group by title

----run1
-- dbt run --select fct_ass5_lookup
--19:21:25  Running with dbt=1.9.3
--19:21:28  Registered adapter: bigquery=1.9.1
--19:21:30  Found 26 models, 35 data tests, 18 sources, 491 macros
--19:21:30
--19:21:30  Concurrency: 2 threads (target='dev')
--19:21:30
--19:21:38  1 of 1 START sql incremental model vanepska.fct_ass5_lookup .................... [RUN]
--19:21:47  1 of 1 OK created sql incremental model vanepska.fct_ass5_lookup ............... [CREATE TABLE (928.8k rows, 439.8 MiB processed) in 8.66s]
--19:21:47
--19:21:47  Finished running 1 incremental model in 0 hours 0 minutes and 16.30 seconds (16.30s).
--19:21:47
--19:21:47  Completed successfully


--run2
--dbt run --select fct_ass5_lookup
--19:30:28  Running with dbt=1.9.3
--19:30:30  Registered adapter: bigquery=1.9.1
--19:30:33  Found 26 models, 35 data tests, 18 sources, 491 macros
--19:30:33
--19:30:33  Concurrency: 2 threads (target='dev')
--19:30:33
--19:30:40  1 of 1 START sql incremental model vanepska.fct_ass5_lookup .................... [RUN]
--19:30:55  1 of 1 OK created sql incremental model vanepska.fct_ass5_lookup ............... [MERGE (557.0k rows, 200.0 MiB processed) in 15.35s]
--19:30:55
--19:30:55  Finished running 1 incremental model in 0 hours 0 minutes and 22.70 seconds (22.70s).
--19:30:55
--19:30:55  Completed successfully
--19:30:55
--19:30:55  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
--PS C:\Users\A\PycharmProjects\course-project-Veron1k>
