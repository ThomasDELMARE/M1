var bicycleRental = {
    "type": "FeatureCollection",
    "features": [
        {
	    "geometry": {
                "type": "Point", 
                "coordinates": [ // lng, lat
		    -106.346771,
		    56.130366
                ]
	    },
	    "type": "Feature",		  
	    "properties": {
                "popupContent": "This is a B-Cycle Station. Come pick up a bike and pay by the hour. What a deal!",
		"url": 'https://en.wikipedia.org/wiki/Canada',
		"name":"Canada"
	    },
	    "id": 51
        },
        {
	    "geometry": {
                "type": "Point", 
                "coordinates": [ // lng, lat
		    -63.068615,
		    18.220554
                ]
	    },
	    "type": "Feature",
	    "properties": {
                "popupContent": "Tehis is a B-Cycle Station. Come pick up a bike and pay by the hour. What a deal!",
		"url": 'https://en.wikipedia.org/wiki/Anguilla',
		"name": "Anguilla"
	    },
	    "id": 52
        },
        {
	    "geometry": {
                "type": "Point", 
                "coordinates": [ // lng, lat
		    -4.202646,
		    56.490671
                ]
	    },
	    "type": "Feature",
	    "properties": {
                "popupContent": "This is a B-Cycle Station. Come pick up a bike and pay by the hour. What a deal!",
		"url": 'https://en.wikipedia.org/wiki/Scotland',
		"name" : "Scotland"
	    },
	    "id": 54
        },
        {
	    "geometry": {
                "type": "Point", 
                "coordinates": [ // lng, lat
		    138.252924, 
		    36.204824
                ]
	    },
	    "type": "Feature",
	    "properties": {
                "popupContent": "This is a B-Cycle Station. Come pick up a bike and pay by the hour. What a deal!",
		"url": 'https://en.wikipedia.org/wiki/Japan',
		"name": "Japan"
	    },
	    "id": 55
        }
    ]
};
const refreshT = 10000 // Refresh period for chart
var layer = null;

function onEachFeature(feature, layer) {
    console.log(feature.name);
    var popupContent = '<p>I started out as a GeoJSON ' +
	feature.geometry.type + ', but now I\'m a Leaflet vector!</p>';
    
    if (feature.properties && feature.properties.popupContent) {
	popupContent += feature.properties.popupContent;
    }
    if (feature.properties && feature.properties.name) {
	popupContent += '<p>';
	popupContent += feature.properties.name;
	popupContent += '</p>';
    }
    
    layer.bindPopup(popupContent);
}

function add_esp(uri){
    // Ajout des données personnelles      
    $.ajax({
	//URL de l'API
	url: uri,
	
	//Type de données
	dataType: "jsonp",
	
	//Méthode appelée lorsque le téléchargement a fonctionné
	success: function(geojson) {
	    //Affichage des données dans la console
	    console.log(geojson);

	    if (layer != null){
		map.removeLayer(layer);
		layer = null;
	    }
	    
	    //Création de la couche à partir du GeoJSON

	    layer = new L.geoJSON(bicycleRental, {		      
		style: function (feature) {
		    return feature.properties && feature.properties.style;
		},    
		onEachFeature: onEachFeature,
		pointToLayer: function (feature, latlng) {
		    return L.circleMarker(latlng, {
		   	radius: 3,
		   	fillColor: '#ff7800',
		   	color: '#000',
		   	weight: 1,
		   	opacity: 1,
		   	fillOpacity: 0.8
		    });
		}
	    }).addTo(map);
	    
	},	      
	//Méthode appelée lorsque le téléchargement a échoué
	error: function() {
	    alert("Erreur lors du téléchargement !");
	}      
    });
}


// Install periodicity
window.setInterval(add_esp,
		   refreshT,
		   "https://data.rennesmetropole.fr/explore/dataset/topologie-des-stations-le-velo-star/download/?format=geojson&timezone=Europe/Berlin",     // URL to GET
		  );   
