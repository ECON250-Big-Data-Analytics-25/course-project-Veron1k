Welcome to your new dbt project!

# Installation

The following tutorial assumes you're already familiar with git and command line usage.

## Getting the code to your local machine
1. Fork this github repository into your local account

2. Copy it to your local machine: `git clone https://github.com/your_account_name/econ250_2025.git`



## gcloud authentication

To run queries from your command line, you'll first need to install `gcloud` utility.

Follow the instructions here: https://cloud.google.com/sdk/docs/install. After installation you should have `gcloud` command available for running in the terminal.

Now, try to authenticate with your **kse email** using the following command: 

```bash
gcloud auth application-default login \
  --scopes=https://www.googleapis.com/auth/bigquery,\
https://www.googleapis.com/auth/drive.readonly,\
https://www.googleapis.com/auth/iam.test,\
https://www.googleapis.com/auth/cloud-platform
```

Now, when you run the following commands something similar should be response: 

```bash
$ gcloud auth list

     Credentialed Accounts
ACTIVE  ACCOUNT
*       o_omelchenko@kse.org.ua

```
To set the active project, run the following: 

```bash
gcloud config set project econ250-2025
```


## venv and libraries
Prerequisites: having Python installed on your machine. 
Following instructions are for Linux or WSL; if you'd like to run Windows - please refer to the documentation below.

```bash

# change directory to the one you just copied from github
cd econ250_2025 

# create and activate venv
python3 -m venv env 
source env/bin/activate

pip install -r requirements.txt

```

If everything is installed correctly, you should run the following commands successfully: 


```
$ dbt --version

Core:
  - installed: 1.9.3
  - latest:    1.9.3 - Up to date!

Plugins:
  - bigquery: 1.9.1 - Up to date!
```


For more detailed reference, refer to the official documentation here: 
- https://docs.getdbt.com/docs/core/pip-install
- https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup#local-oauth-gcloud-setup

## Adjusting the configuration

You'll need to specify your own dataset to save your models to. To do so, navigate to the `profiles.yml` in the root directory of the project, and replace `o_omelchenko` with your bigquery dataset name with which you have been working previously.




## Final check

Try running the following command:
- dbt run

If everything is set up well, you will see similar output: 

```log
❯ dbt run
01:18:56  Running with dbt=1.9.3
01:18:57  Registered adapter: bigquery=1.9.1
01:18:57  Found 2 models, 4 data tests, 491 macros
01:18:57  
01:18:57  Concurrency: 2 threads (target='dev')
01:18:57  
01:19:00  1 of 2 START sql table model o_omelchenko.my_first_dbt_model ................... [RUN]
01:19:04  1 of 2 OK created sql table model o_omelchenko.my_first_dbt_model .............. [CREATE TABLE (2.0 rows, 0 processed) in 4.44s]
01:19:04  2 of 2 START sql view model o_omelchenko.my_second_dbt_model ................... [RUN]
01:19:06  2 of 2 OK created sql view model o_omelchenko.my_second_dbt_model .............. [CREATE VIEW (0 processed) in 2.13s]
01:19:06  
01:19:06  Finished running 1 table model, 1 view model in 0 hours 0 minutes and 9.64 seconds (9.64s).
```

If you have any troubles with installation, please contact the course instructor (Oleh Omelchenko) in slack for assist.



## Final Project Overview

In this final project, I applied the skills learned throughout the course to build an end-to-end
analytics engineering solution using the Brazilian E-commerce dataset. The project involved 
working with Google BigQuery and dbt to import, transform, and analyze e-commerce data. Below is
a breakdown of each part of the project and the steps I took to complete it.


### Part 1

The first step was to upload the Brazilian E-commerce dataset to Google BigQuery. I downloaded 
the data from Kaggle and loaded the relevant CSV files into my BigQuery project (econ250-2025). 
I kept consistent table naming for the source tables (e.g., `fp_customers` for `olist_customers_dataset.csv`).

After uploading the data, I performed exploratory data analysis to understand the relationships 
between the tables and identify which tables would be used in the subsequent steps.


### Part 2

In this part, I created a new file `fp_sources.yml` in my dbt project to define the sources
for each of the tables I uploaded to BigQuery (e.g., `olist_customers_dataset.csv`, 
`olist_orders_dataset.csv`, etc.). I also added descriptions for the columns in each source file,
making it easier to understand the data for future use and modeling.


### Part 3

Next, I created staging models for each of the source tables. The purpose of these models was
to clean and transform the raw data into a more usable form. This involved converting data types, 
handling null values (especially for categorical columns), and implementing any necessary data
quality checks. For example, I created derived columns like the time between the order time and 
delivery date.


### Part 4

For the integrated data model, I combined the information from various source tables into 
a single model called `fp_sales_full`. This model serves as a denormalized view that combines 
data from `orders`, `products`, `customers`, and other tables. I materialized the resulting model 
as a table in BigQuery, specifying appropriate partitioning and clustering for better performance.

I documented the decisions I made during this process and included detailed descriptions of the 
fields in the model (both original columns and new derived ones).


### Part 5

I implemented several analytical mart models to generate insights from the data. Some of the 
models I created include:
 

- **Product Performance**: I analyzed top-performing products based on different criteria, 
- including region and price category.

- **Seller Analytics**: This model evaluates seller performance metrics, such as fulfillment 
- efficiency and time differences between order stand and order shipment.

- **Payment Analysis**: This model analyzes various payment-related trends in the dataset. It 
- focuses on key metrics


### Part 6

In this part of the project, I added data tests for the models to ensure data quality.
I implemented at least two custom data tests, such as comparing total sales numbers between 
`fp_sales_full` and the mart models to check for consistency. Additionally, I provided comprehensive 
documentation for each table and key columns, which was passed downstream to the BigQuery interface 
using the `persist_docs` feature in dbt.

