#!usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 20 10:28:26 2024
script pyspark
"""
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, avg,count, desc

spark = SparkSession.builder \
    .appName("Analyse des données de grades") \
    .master("YARN") \
    .getOrCreate()
sc = spark.sparkContext
rdd = sc.textFile("hdfs:///grades.csv")
rdd.take(5)

spark.stop()