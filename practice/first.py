from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
data = [(1, "Prabhu"),(2, "Avinash"), (3, "Jagadeesh")]
schema = ["id", "name"]
df = spark.createDataFrame(data=data,schema=schema)
df.show()
