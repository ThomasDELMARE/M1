window.onload = init;

function init() {
    new Vue({
        el: "#app",
        data: {
            restaurants: [],
            nom: '',
            cuisine: '',
            nbRestaurantsTotal: 0,
            page: 0,
            pagesize: 10,
            nbPagesTotal: 0,
            dernierePage: 0,
            sliderValue: 0,
            restaurantName: ""
        },
        methods: {
            supprimerRestaurant(r) {
                let restaurantASupprimer = r._id;
                let url = "http://localhost:8080/api/restaurants/" + restaurantASupprimer;

                fetch(url, {
                    method: "DELETE"
                })
                    .then((responseJSON) => {
                        responseJSON.json()
                            .then((res) => {
                                // Maintenant res est un vrai objet JavaScript
                                console.log("Restaurant ajouté, " + res.msg);
                                // On rafraichit la vue
                                this.getRestaurantsFromServer()
                            });
                    })
                    .catch((err) => {
                        console.log(err);
                    });

                this.nom = "";
                this.cuisine = "";
            },
            getColor(index) {
                return (index % 2) ? 'lightBlue' : 'pink';
            },
            getRestaurantsFromServer() {
                this.sliderValue = document.getElementById("sliderPage").value;
                this.restaurantName = document.getElementById("restaurantName").value;

                let url = "http://localhost:8080/api/restaurants?";
                url += "page=" + this.page;
                url += "&pagesize=" + this.sliderValue;

                if (this.restaurantName != null || this.restaurantName != "") {
                    url += "&name=" + this.restaurantName;
                }

                fetch(url)
                    // On obtient la réponse en JSON
                    .then((responseJSON) => {
                        // On convertit la réponse JSON qui va la transformer en objet JS
                        responseJSON.json()
                            .then((res) => {
                                // Maintenant res est un vrai objet JavaScript
                                if (this.sliderValue == 0) {
                                    this.restaurants = [];
                                }
                                else {
                                    this.restaurants = res.data;
                                }

                                this.nbRestaurantsTotal = res.count;
                                this.nbPagesTotal = Math.round(this.nbRestaurantsTotal / this.pagesize);
                            });
                    })
                    .catch(function (err) {
                        console.log(err);
                    });
            },
            pageSuivante() {
                if (this.page === this.nbPagesTotal) {
                    return;
                }
                this.page++;
                this.getRestaurantsFromServer()
            },
            pagePrecedente() {
                if (this.page === 0) {
                    return;
                }

                this.page--;
                this.getRestaurantsFromServer()
            },
            getRestaurantByName:
                _.debounce(function () {
                    this.getRestaurantsFromServer();
                }, 1000),
            ajouterRestaurant(event) {
                // eviter le comportement par defaut
                event.preventDefault();

                let form = event.target;
                let donneesFormulaire = new FormData(form);
                let url = "http://localhost:8080/api/restaurants";

                fetch(url, {
                    method: "POST",
                    body: donneesFormulaire
                })
                    .then((responseJSON) => {
                        responseJSON.json()
                            .then((res) => {
                                // Maintenant res est un vrai objet JavaScript
                                console.log("Restaurant ajouté, " + res.msg);
                                // On rafraichit la vue
                                this.getRestaurantsFromServer()
                            });
                    })
                    .catch((err) => {
                        console.log(err);
                    });

                this.nom = "";
                this.cuisine = "";
            },
        },
        mounted() {
            console.log("AVANT RENDU HTML");

            if (window.XMLHttpRequest) {
                request = new XMLHttpRequest();
            }
            else if (window.ActiveXObject) { // IE
                try {
                    request = new ActiveXObject('Msxml2.XMLHTTP');
                }
                catch (e) {
                    try {
                        request = new ActiveXObject('Microsoft.XMLHTTP');
                    }
                    catch (e) { }
                }
            }

            this.getRestaurantsFromServer();
        }
    })
}