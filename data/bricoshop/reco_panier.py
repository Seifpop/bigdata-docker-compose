# =============================================================================
# BricoShop - Recommandations en direct (etape 6 du mini-projet)
#
# Chaque fois qu'un client ajoute un produit a son panier, le site web envoie
# un message dans Kafka, par exemple :   101,Marteau
# Ce programme lit ces messages en continu et affiche, pour chacun :
#   - les produits a proposer (calcules a l'etape 4, "souvent achetes ensemble")
#   - la promotion en cours sur ce produit, s'il y en a une
#
# Il reste 3 trous a completer : cherchez "TROU".
#
# Lancement (dans le conteneur master) :
#   spark-submit --master "local[2]" \
#     --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.0.0 \
#     /data/bricoshop/reco_panier.py
# =============================================================================
from pyspark.sql import SparkSession, functions as F

spark = SparkSession.builder.appName("reco-panier").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")
B = "/user/stagiaire/bricoshop"

# -----------------------------------------------------------------------------
# 1. Ce qui a ete calcule a l'avance (etape 4) : 3 suggestions par produit.
#    On les met sur une seule ligne : "Clous, Pince, Gants"
# -----------------------------------------------------------------------------
assoc = spark.read.csv(B + "/associations", inferSchema=True) \
             .toDF("produit", "produit_associe", "nb_clients", "rang")
suggestions = assoc.groupBy("produit").pivot("rang", [1, 2, 3]) \
                   .agg(F.first("produit_associe")) \
                   .select("produit", F.concat_ws(", ", "1", "2", "3").alias("suggestions"))

# -----------------------------------------------------------------------------
# 2. Les promotions en cours
# -----------------------------------------------------------------------------
promos = spark.read.csv(B + "/raw/promos", header=True, inferSchema=True)

# -----------------------------------------------------------------------------
# 3. Le flux des ajouts au panier, envoye par le site web dans Kafka
# -----------------------------------------------------------------------------
# TROU 1 : l'adresse de Kafka vue depuis le conteneur, et le nom du sujet
flux = (spark.readStream.format("kafka")
        .option("kafka.bootstrap.servers", "________")
        .option("subscribe", "________")
        .load())

# TROU 2 : Kafka rend le message en binaire dans la colonne "value".
#          Convertissez-le en texte, dans une colonne nommee "message".
messages = flux.selectExpr("________")

# Un message ressemble a "101,Marteau" : on le coupe en deux colonnes.
# trim + initcap : " marteau " devient "Marteau", comme dans le catalogue.
paniers = messages.select(
    F.split("message", ",").getItem(0).alias("id_client"),
    F.initcap(F.trim(F.split("message", ",").getItem(1))).alias("produit"))

# -----------------------------------------------------------------------------
# 4. On rapproche chaque ajout de ses suggestions et de sa promo
# -----------------------------------------------------------------------------
# TROU 3 : quel type de jointure faut-il pour qu'un produit SANS suggestion
#          ni promo s'affiche quand meme ?
reco = paniers.join(suggestions, "produit", "________") \
              .join(promos, "produit", "________")

# -----------------------------------------------------------------------------
# 5. Affichage, comme le ferait le site web (rien a modifier)
# -----------------------------------------------------------------------------
def afficher(lot, numero):
    for l in lot.collect():
        print("")
        print("Client " + str(l["id_client"]) + " a ajoute : " + str(l["produit"]))
        if l["suggestions"]:
            print("   Proposer aussi : " + l["suggestions"])
        else:
            print("   Pas de suggestion pour ce produit")
        if l["pack"]:
            print("   PROMO " + l["pack"] + " (" + l["contenu"] + ") : -"
                  + str(l["remise"]) + " %")

reco.writeStream.foreachBatch(afficher).start().awaitTermination()
