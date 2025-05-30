import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame
from pyspark.sql.functions import to_timestamp, col,regexp_extract
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

datasource0 = glueContext.create_dynamic_frame.from_catalog(
    database="users_catalog", 
    table_name="users",         
    transformation_ctx="datasource0"
)

users_df = datasource0.toDF()

email_regex_pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"


processed_users_df = users_df.withColumn(
  "created_at",
  to_timestamp(col("created_at"), "yyyy-MM-dd HH:mm:ss")
).filter(
  (col("email").isNotNull()) & (regexp_extract(col("email"), email_regex_pattern, 0) != "")
)

glueContext.write_dynamic_frame.from_jdbc_conf(
    frame = DynamicFrame.fromDF(processed_users_df, glueContext, "processed_users_df_final"),
    catalog_connection = "your-rds-mysql-connection",
    connection_options = {
        "dbtable": "users", 
        "database": "mydb" 
    },
    redshift_tmp_dir = args["TempDir"],
    transformation_ctx = "datasink0"
)

job.commit()