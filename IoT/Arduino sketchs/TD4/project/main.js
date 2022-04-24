// Imports
const express = require('express');
const { MongoClient, ServerApiVersion, MongoCursorInUseError } = require('mongodb');
const path = require('path');

// Déclarations
const app = express();
const port = process.env.PORT || 3000;;
// Tout le monde peut accéder à la bdd
const uri = "mongodb+srv://thomasdelmare:thomasdelmare@cluster0.hotx2.mongodb.net/weather_map?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true, serverApi: ServerApiVersion.v1 });




// APP CONFIGURATION
app.use(require("cors")()); // Accepte les requêtes inter domaines
app.use(require("body-parser").json()); // Parse automatiquement les JSON des requêtes
app.use("/maps", express.static(path.join(__dirname, '/maps/'))); // Permet d'utiliser les scripts dans henoku


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/index.html'));
});

app.get("/test", (req, res) => {

});

app.listen(port, async() => {
    console.log(`App running on localhost, port : ${port}!`)

    try {
        await client.connect();
        const collection = client.db("weather_map").collection("esp_list");

        // Permet de savoir la taille estimée de la BDD
        const estimate = await collection.estimatedDocumentCount();
        console.log(`Estimated number of documents in the collection: ${estimate}`);

        // Query de test pour voir si on peut fetch
        const query = { "nom": "test" };

        // On compte le nombre de requêtes qu'on a trouvé
        const countCanada = await collection.countDocuments(query);
        console.log(`Number of result fetched : ${countCanada}`);

        if (countCanada > 0) {
            // Traitement de l'objet trouvé
            var cursor = collection.find(query)
            var cursorArray = await cursor.toArray()

            console.log("Résultat : ", cursorArray)
            console.log("Type de cursorarray : ", typeof cursorArray)
            console.log("Type de cursorarray : ", cursorArray[0].nom)

        }

        // Ajout d'un document
        const insertQuery = {
            nom: "NODEJS",
            adresse: "localhost",
        }

        const insertResult = await collection.insertOne(insertQuery);
        console.log(`Un document a été inséré avec l'id : ${insertResult.insertedId}`);

        // Suppression de document
        const deleteResult = await collection.deleteOne(insertQuery);
        if (deleteResult.deletedCount === 1) {
            console.log("Le document a bien été supprimé !");
        } else {
            console.log("Aucun document n'a été trouvé avec cette query, 0 document ont été supprimé.");
        }

    } finally {
        await client.close();
    }
});