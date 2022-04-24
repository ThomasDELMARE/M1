//
//See post: https://asmaloney.com/2014/01/code/creating-an-interactive-map-with-leaflet-and-openstreetmap/
var markers = [
    //  {
    //   name: 'Canada',
    //   url: 'https://en.wikipedia.org/wiki/Canada',
    //   lat: 56.130366,
    //   lng: -106.346771,
    // },
    // {
    //   name: 'Anguilla',
    //   url: 'https://en.wikipedia.org/wiki/Anguilla',
    //   lat: 18.220554,
    //   lng: -63.068615,
    // },
    {
        name: 'Barbados',
        url: 'https://en.wikipedia.org/wiki/Barbados',
        lat: 13.193887,
        lng: -59.543198,
    },
    {
        name: 'United States',
        url: 'https://en.wikipedia.org/wiki/United_States',
        lat: 37.09024,
        lng: -95.712891,
    },
    {
        name: 'Ireland',
        url: 'https://en.wikipedia.org/wiki/Ireland',
        lat: 53.41291,
        lng: -8.24389,
    },
    // {
    //   name: 'Scotland',
    //   url: 'https://en.wikipedia.org/wiki/Scotland',
    //   lat: 56.490671,
    //   lng: -4.202646,
    // },
    {
        name: 'England',
        url: 'https://en.wikipedia.org/wiki/England',
        lat: 52.355518,
        lng: -1.17432,
    },
    {
        name: 'France',
        url: 'https://en.wikipedia.org/wiki/France',
        lat: 46.227638,
        lng: 2.213749,
    },
    {
        name: 'The Netherlands',
        url: 'https://en.wikipedia.org/wiki/The_Netherlands',
        lat: 52.132633,
        lng: 5.291266,
    },
    {
        name: 'Switzerland',
        url: 'https://en.wikipedia.org/wiki/Switzerland',
        lat: 46.818188,
        lng: 8.227512,
    },
    {
        name: 'South Africa',
        url: 'https://en.wikipedia.org/wiki/South_Africa',
        lat: -30.559482,
        lng: 22.937506,
    },
    {
        name: 'Madagascar',
        url: 'https://en.wikipedia.org/wiki/Madagascar',
        lat: -18.766947,
        lng: 46.869107,
    },
    {
        name: 'Taiwan',
        url: 'https://en.wikipedia.org/wiki/Taiwan',
        lat: 23.69781,
        lng: 120.960515,
    },
    // {
    //   name: 'Japan',
    //   url: 'https://en.wikipedia.org/wiki/Japan',
    //   lat: 36.204824,
    //   lng: 138.252924,
    // },
    {
        name: 'Argentina',
        url: 'https://en.wikipedia.org/wiki/Argentina',
        lat: -38.416096,
        lng: -63.616673,
    },
]

var myURL = jQuery('script[src$="static_markers.js"]')
    .attr('src')
    .replace('static_markers.js', '')

var myIcon = L.icon({
    iconUrl: myURL + 'images/pin24.png',
    iconRetinaUrl: myURL + 'images/pin48.png',
    iconSize: [29, 24],
    iconAnchor: [9, 21],
    popupAnchor: [0, -14],
})

for (var i = 0; i < markers.length; ++i) {
    L.marker([markers[i].lat, markers[i].lng], { icon: myIcon })
        .bindPopup(
            '<a href="' +
            markers[i].url +
            '" target="_blank">' +
            markers[i].name +
            '</a>'
        )
        .addTo(map)
}