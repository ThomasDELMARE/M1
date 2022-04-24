// Importation des modules
var path = require('path');

// var, const, let :
// https://medium.com/@vincent.bocquet/var-let-const-en-js-quelles-diff%C3%A9rences-b0f14caa2049

//--- MQTT module
const mqtt = require('mqtt')
// Topics MQTT
const TOPIC_LIGHT = 'sensors/light'
const TOPIC_TEMP  = 'sensors/temp'

//---  The MongoDB module exports MongoClient, and that's what
// we'll use to connect to a MongoDB database.
// We can use an instance of MongoClient to connect to a cluster,
// access the database in that cluster,
// and close the connection to that cluster.
const {MongoClient} = require('mongodb');

//----------------------------------------------------------------
// This function will retrieve a list of databases in our cluster and
// print the results in the console.
async function listDatabases(client){
    databasesList = await client.db().admin().listDatabases();
    
    console.log("Databases in Mongo Cluster : \n");
    databasesList.databases.forEach(db => console.log(` - ${db.name}`));
};

//----------------------------------------------------------------
// asynchronous function named main() where we will connect to our
// MongoDB cluster, call functions that query our database, and
// disconnect from our cluster.
async function v0(){
    const mongoName = "lucioles"                   //Nom de la base
    const mongoUri = 'mongodb://localhost:27017/'; //URL de connection		
    //const uri = 'mongodb://10.9.128.189:27017/'; //URL de connection		
    //const uri = 'mongodb+srv://menez:mettrelevotre@cluster0-x0zyf.mongodb.net/test?retryWrites=true&w=majority';
    
    //Now that we have our URI, we can create an instance of MongoClient.
    const mg_client = new MongoClient(mongoUri,
				      {useNewUrlParser:true, useUnifiedTopology:true});

    // Connect to the MongoDB cluster
    mg_client.connect(function(err,  mg_client){
	if(err) throw err; // If connection to DB failed ... 
   
	//===============================================    
	// Print databases in our cluster
	listDatabases(mg_client);

	//===============================================    
	// Get a connection to the DB "lucioles" or create
	dbo = mg_client.db(mongoName);

	// Remove "old collections : temp and light
	dbo.listCollections({name: "temp"})
	    .next(function(err, collinfo) {
		if (collinfo) { // The collection exists
		    //console.log('Collection temp already exists');
		    dbo.collection("temp").drop() 
		}
	    });

	dbo.listCollections({name: "light"})
	    .next(function(err, collinfo) {
		if (collinfo) { // The collection exists
		    //console.log('Collection temp already exists');
		    dbo.collection("light").drop() 
		}
	    });

	//===============================================
	// Connexion au broker MQTT distant
	//
	//const mqtt_url = 'http://192.168.1.11:1883'
	const mqtt_url = 'http://broker.hivemq.com'
	var client_mqtt = mqtt.connect(mqtt_url);
	
	//===============================================
	// Des la connexion, le serveur NodeJS s'abonne aux topics MQTT 
	//
	client_mqtt.on('connect', function () {
	    client_mqtt.subscribe(TOPIC_LIGHT, function (err) {
		if (!err) {
		    //client_mqtt.publish(TOPIC_LIGHT, 'Hello mqtt')
		    console.log('Node Server has subscribed to ', TOPIC_LIGHT);
		}
	    })
	    client_mqtt.subscribe(TOPIC_TEMP, function (err) {
		if (!err) {
		    //client_mqtt.publish(TOPIC_TEMP, 'Hello mqtt')
		    console.log('Node Server has subscribed to ', TOPIC_TEMP);
		}
	    })
	})

	//================================================================
	// Callback de la reception des messages MQTT pour les topics sur
	// lesquels on s'est inscrit.
	// => C'est cette fonction qui alimente la BD !
	//
	client_mqtt.on('message', function (topic, message) {
	    console.log("\nMQTT msg on topic : ", topic.toString());
	    console.log("Msg payload : ", message.toString());

	    // Parsing du message supposé recu au format JSON
	    message = JSON.parse(message);
	    wh = message.who
	    val = message.value

	    // Debug : Gerer une liste de who pour savoir qui utilise le node server	
	    let wholist = []
	    var index = wholist.findIndex(x => x.who==wh)
	    if (index === -1){
		wholist.push({who:wh});	    
	    }
	    console.log("wholist using the node server :", wholist);

	    // Mise en forme de la donnee à stocker => dictionnaire
	    // Le format de la date est iomportant => compatible avec le
	    // parsing qui sera realise par hightcharts dans l'UI
	    // cf https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_tolocalestring_date_all
	    // vs https://jsfiddle.net/BlackLabel/tgahn7yv
	    // var frTime = new Date().toLocaleString("fr-FR", {timeZone: "Europe/Paris"});
	    var frTime = new Date().toLocaleString("sv-SE", {timeZone: "Europe/Paris"});
	    var new_entry = { date: frTime, // timestamp the value 
			      who: wh,      // identify ESP who provide 
			      value: val    // this value
			    };
	    
	    // On recupere le nom basique du topic du message
	    var key = path.parse(topic.toString()).base;
	    // Stocker le dictionnaire qui vient d'etre créé dans la BD
	    // en utilisant le nom du topic comme key de collection
	    dbo.collection(key).insertOne(new_entry, function(err, res) {
		if (err) throw err;
		console.log("\nItem : ", new_entry, 
		"\ninserted in db in collection :", key);
	    });

	    // Debug : voir les collections de la DB 
	    //dbo.listCollections().toArray(function(err, collInfos) {
		// collInfos is an array of collection info objects
		// that look like: { name: 'test', options: {} }
	    //	console.log("List of collections currently in DB: ", collInfos); 
	    //});
	}) // end of 'message' callback installation

	//================================================================
	// Fermeture de la connexion avec la DB lorsque le NodeJS se termine.
	//
	process.on('exit', (code) => {
	    if (mg_client && mg_client.isConnected()) {
		console.log('mongodb connection is going to be closed ! ');
		mg_client.close();
	    }
	})
	
    });// end of MongoClient.connect
}// end def main

//================================================================
//==== Demarrage BD et MQTT =======================
//================================================================
v0().catch(console.error);

//====================================
// Utilisation du framework express
// Notamment gérér les routes 
const express = require('express');
// et pour permettre de parcourir les body des requetes
const bodyParser = require('body-parser');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use(express.static(path.join(__dirname, '/')));
app.use(function(request, response, next) { //Pour eviter les problemes de CORS/REST
    response.header("Access-Control-Allow-Origin", "*");
    response.header("Access-Control-Allow-Headers", "*");
    response.header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE");
    next();
});

//================================================================
// Answering GET request on this node ... probably from navigator.
// => REQUETES HTTP reconnues par le Node
//================================================================
    
// Route / => Le node renvoie la page HTML affichant les charts
app.get('/', function (req, res) {
    res.sendFile(path.join(__dirname + '/ui_lucioles.html'));
});


// The request contains the name of the targeted ESP !
//     /esp/temp?who=80%3A7D%3A3A%3AFD%3AC9%3A44
// Exemple d'utilisation de routes dynamiques
//    => meme fonction pour /esp/temp et /esp/light
app.get('/esp/:what', function (req, res) {
    // cf https://stackabuse.com/get-query-strings-and-parameters-in-express-js/
    console.log(req.originalUrl);
    
    wh = req.query.who // get the "who" param from GET request
    // => gives the Id of the ESP we look for in the db	
    wa = req.params.what // get the "what" from the GET request : temp or light ?
    
    console.log("\n--------------------------------");
    console.log("A client/navigator ", req.ip);
    console.log("sending URL ",  req.originalUrl);
    console.log("wants to GET ", wa);
    console.log("values from object ", wh);
    
    // Récupération des nb derniers samples stockés dans
    // la collection associée a ce topic (wa) et a cet ESP (wh)
    const nb = 200;
    key = wa
    //dbo.collection(key).find({who:wh}).toArray(function(err,result) {
    dbo.collection(key).find({who:wh}).sort({_id:-1}).limit(nb).toArray(function(err, result) {
	if (err) throw err;
	console.log('get on ', key);
	console.log(result);
	res.json(result.reverse()); // This is the response.
	console.log('end find');
    });
    console.log('end app.get');
});

//================================================================
//==== Demarrage du serveur Web  =======================
//================================================================
// L'application est accessible sur le port 3000

app.listen(3000, () => {
    console.log('Server listening on port 3000');
});
