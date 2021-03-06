var bicycleRental = {
    "type": "FeatureCollection",
    "features": [{
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
                "name": "Canada"
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
                "name": "Scotland"
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

function add_esp(uri) {
    // Ajout des donn??es personnelles      
    $.ajax({
        //URL de l'API
        url: uri,

        //Type de donn??es
        dataType: "jsonp",

        //M??thode appel??e lorsque le t??l??chargement a fonctionn??
        success: function(geojson) {

            // ========= Markers obtenus par la requete
            //Affichage des donn??es dans la console
            // console.log(geojson);
            //Cr??ation de la couche ?? partir du GeoJSON
            var layer_url = L.geoJSON(geojson);
            //Ajout de popup sur chaque objet
            layer_url.bindPopup(function(layer) {
                console.log(layer.feature.properties);
                return "Nom station : " + layer.feature.properties.nom + "<br/> " + layer.feature.properties.nombreemplacementstheorique + " emplacements";
            });
            //Ajout de la couche sur la carte
            layer_url.addTo(map);


            // ========= Markers statiques 
            if (layer != null) {
                map.removeLayer(layer);
                layer = null;
            }

            //Cr??ation de la couche ?? partir du GeoJSON
            layer = new L.geoJSON(bicycleRental, {
                style: function(feature) {
                    return feature.properties && feature.properties.style;
                },
                onEachFeature: onEachFeature,
                pointToLayer: function(feature, latlng) {
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
        //M??thode appel??e lorsque le t??l??chargement a ??chou??
        error: function() {
            alert("Erreur lors du t??l??chargement !");
        }
    });
}


// Install periodicity
window.setInterval(add_esp,
    refreshT,
    "https://data.rennesmetropole.fr/explore/dataset/topologie-des-stations-le-velo-star/download/?format=geojson&timezone=Europe/Berlin", // URL to GET
);