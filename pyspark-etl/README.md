# Read the word count from text file and write to postgresql database

![pyspark etl](pyspark-etl.png)

After executing `etl.py` we can see results in postgresql database 
```
$ psql -h localhost -U prabhu -d pyspark

pyspark=# SELECT count(*) FROM documentation.word_count;
 count
-------
   265
(1 row)

pyspark=#
```

#### Invoking pyspark from command line and connecting to postgresql database 
Prerequisites: JDBC driver for postgresql database need to be downloaded from this [link](https://jdbc.postgresql.org)
```
$ pyspark --jars pyspark-etl/postgresql-42.6.0.jar
>>> driver = "org.postgresql.Driver"
>>> url="jdbc:postgresql://localhost/pyspark"
>>> dbtable="documentation.word_count"
>>> user="prabhu"
>>> password=""
>>> jdbcDF = spark.read \
...     .format("jdbc") \
...     .option("driver", driver) \
...     .option("url", url) \
...     .option("dbtable", dbtable) \
...     .option("user", user) \
...     .option("password", password) \
...     .load()
>>> jdbcDF.show()
+---+------+                                                                    
| id|  name|
+---+------+
|  1|prabhu|
+---+------+
```
