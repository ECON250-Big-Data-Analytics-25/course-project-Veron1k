{{
config(
materialized = 'incremental',
incremental_strategy = "insert_overwrite",
partition_by = { "field": "date", "data_type": "date"}
        )
}}

select
    date(datehour) as date,
    title,
    sum(views) as views,
    current_timestamp() as insert_time
from {{ source('test_dataset', 'assignment5_input') }}

{% if is_incremental() %}
    where date(datehour) >= _dbt_max_partition - 1
{% endif %}

group by 1, 2



-- run 1
-- dbt run --select fct_assignment5_totals
--15:47:52  Running with dbt=1.9.3
--15:47:55  Registered adapter: bigquery=1.9.1
--15:47:57  Found 23 models, 35 data tests, 18 sources, 491 macros
--15:47:57
--15:47:57  Concurrency: 2 threads (target='dev')
--15:47:57
--15:48:12  1 of 1 START sql incremental model vanepska.fct_assignment5_totals ............. [RUN]
--15:48:22
--15:48:22  Finished running 1 incremental model in 0 hours 0 minutes and 25.21 seconds (25.21s).
--15:48:22
--15:48:22  Completed successfully
--15:48:22
--15:48:22  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1

--
--run 1 with insert_time
--dbt run --select fct_assignment5_totals
--16:15:53  Running with dbt=1.9.3
--16:15:55  Registered adapter: bigquery=1.9.1
--16:15:58  Found 23 models, 35 data tests, 18 sources, 491 macros
--16:15:58
--16:15:58  Concurrency: 2 threads (target='dev')
--16:15:58
--16:16:05  1 of 1 START sql incremental model vanepska.fct_assignment5_totals ............. [RUN]
--16:16:14  1 of 1 OK created sql incremental model vanepska.fct_assignment5_totals ........ [CREATE TABLE (2.4m rows, 439.8 MiB processed) in 9.67s]
--16:16:14
--16:16:14  Finished running 1 incremental model in 0 hours 0 minutes and 16.87 seconds (16.87s).
--16:16:15
--16:16:15  Completed successfully


--run 2 with insert_time
-- dbt run --select fct_assignment5_totals
--16:56:20  Running with dbt=1.9.3
--16:56:23  Registered adapter: bigquery=1.9.1
--16:56:26  Found 24 models, 35 data tests, 18 sources, 491 macros
--16:56:26
--16:56:26  Concurrency: 2 threads (target='dev')
--16:56:26
--16:56:34  1 of 1 START sql incremental model vanepska.fct_assignment5_totals ............. [RUN]
--16:56:50  1 of 1 OK created sql incremental model vanepska.fct_assignment5_totals ........ [SCRIPT (262.5 MiB processed) in 15.86s]
--16:56:50
--16:56:50  Finished running 1 incremental model in 0 hours 0 minutes and 23.21 seconds (23.21s).
--16:56:50
--16:56:50  Completed successfully
--16:56:50
--16:56:50  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
--PS C:\Users\A\PycharmProjects\course-project-Veron1k>

