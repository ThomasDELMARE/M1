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
    
    console.log("Mongo : Databases in Cluster/Server are ");
    databasesList.databases.forEach(db => console.log(` \t \t- ${db.name}`));
};

//----------------------------------------------------------------
// asynchronous function named main() where we will connect to our
// MongoDB cluster, call functions that query our database, and
// disconnect from our cluster.
async function main(){
    const mongoName = "lucioles"                   // Nom de la base
    const mongoUri = 'mongodb://localhost:27017/'; // connection  URI	
    //const uri = 'mongodb://10.9.128.189:27017/'; 
    //const uri = 'mongodb+srv://menez:mettrelevotre@cluster0-x0zyf.mongodb.net/test?retryWrites=true&w=majority';
    
    //Now that we have our URI, we can create an instance of MongoClient.
    const mg_client = new MongoClient(mongoUri,
				      {useNewUrlParser:true, useUnifiedTopology:true});

    // Connect to the MongoDB cluster/server
    mg_client.connect(function(err,  mg_client){
	if (err) throw err; // If connection to DB failed ... 
	
	// else
	mg_client.db("admin").command({ ping: 1 });
	console.log("Mongo : \"mg_client\" connected successfully to server !");
	
	//===============================================    
	// Print databases in our cluster
	listDatabases(mg_client);

	//===============================================    
	// Get a connection to the DB "lucioles" or create
	dbo = mg_client.db(mongoName); // AUTOMATICALLY GLOBAL VARIABLE !!
	console.log("Mongo : DB \"lucioles\" connected/created !");
	
	// This Remove "old collections : temp and light
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
	console.log("Mongo : Collection \"temp\" and \"light\" created or erased (dropped) !");

	
	//===============================================
	// Connexion au broker MQTT distant
	//
	const mqtt_url = 'http://192.168.1.101:1883'
	//const mqtt_url = 'http://broker.hivemq.com'
	var options={
	    clientId:"deathstar_base",
	    username:"darkvador",
	    password:"6poD2R2",
	    clean:true};
	var client_mqtt = mqtt.connect(mqtt_url,options);
	
	//===============================================
	// Connection success raises a connect event 
	// => now serveur NodeJS can subscribe to topics !
	client_mqtt.on('connect', function () {

	    console.log("MQTT : Node JS connected to MQTT broker !");
	    
	    client_mqtt.subscribe(TOPIC_LIGHT, function (err) {
		if (!err) {
		    //client_mqtt.publish(TOPIC_LIGHT, 'Hello mqtt')
		    console.log('MQTT : Node Server has subscribed to \"', TOPIC_LIGHT, '\"');
		}
	    })
	    client_mqtt.subscribe(TOPIC_TEMP, function (err) {
		if (!err) {
		    //client_mqtt.publish(TOPIC_TEMP, 'Hello mqtt')
		    console.log('MQTT : Node Server has subscribed to \"', TOPIC_TEMP, '\"');
		}
	    })
	})

	//================================================================
	// Callback de la reception des messages MQTT pour les topics sur
	// lesquels on s'est inscrit.
	// => C'est cette fonction qui alimente la BD !
	//
	client_mqtt.on('message', function (topic, message) {
	    console.log("\nMQTT Reception of msg on topic : ", topic.toString());
	    console.log("\tPayload : ", message.toString());

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
	    console.log("NODE JS : who is using the node server ? =>", wholist);

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
		console.log("\nMONGO : \t Item : ", new_entry, 
		"\nhas been inserted in db in collection :", key);
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
		console.log('MONGO : mongodb connection is going to be closed ! ');
		mg_client.close();
	    }
	})
	
    });// end of MongoClient.connect
}// end def main

//====================================
main().catch(console.error);
