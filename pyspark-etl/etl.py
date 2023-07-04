from pyspark.sql import SparkSession
from pyspark.sql.functions import split, explode

# Extract
spark = SparkSession.builder.config("spark.jars","pyspark-etl/postgresql-42.6.0.jar").getOrCreate()
df = spark.read.text("pyspark-etl/documentation.txt")

# # Transform
df2 = df.withColumn("splittedData", split("value", " "))
df3 = df2.withColumn("words", explode("splittedData"))
wordsDF = df3.select("words")
wordCount = wordsDF.groupBy("words").count()

# Load
driver = "org.postgresql.Driver"
url="jdbc:postgresql://localhost/pyspark"
dbtable="documentation.word_count"
user="prabhu"
password=""
wordCount.write \
    .format("jdbc") \
    .option("driver", driver) \
    .option("url", url) \
    .option("dbtable", dbtable) \
    .option("user", user) \
    .option("password", password) \
    .save()
