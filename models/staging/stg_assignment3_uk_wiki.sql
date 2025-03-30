select
        datehour,
        title,
        views,
        "desktop" as src,
        extract(date from datehour) as date,
        extract(dayofweek from datehour) as day_of_week,
        extract(hour from datehour) as hour_of_day
    from {{ source("test_dataset", "assignment3_input_uk") }}

    UNION ALL

    select
        datehour,
        title,
        views,
        "mobile" as src,
        extract(date from datehour) as date,
        extract(dayofweek from datehour) as day_of_week,
        extract(hour from datehour) as hour_of_day
    from {{ source("test_dataset", "assignment3_input_uk_m") }}