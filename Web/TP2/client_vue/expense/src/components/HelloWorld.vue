<template>
  <div id="HelloWorld">
    <h1>Application de gestion de restaurants :</h1>

    <br />

    <!-- <h1>Nombre de restaurants : {{ nbRestaurantsTotal }}</h1> -->
    <!-- <p>Nb pages totales : {{ nbPagesTotal }}</p> -->

    <form v-on:submit="ajouterRestaurant">
      <label>
        Nom : <md-input name="nom" type="text" required v-model="nom" />
      </label>
      <label>
        Cuisine :
        <input name="cuisine" type="text" required v-model="cuisine" />
      </label>

      <button>Ajouter</button>
    </form>

    <br />

    <form>
      <label> Rechercher un restaurant : </label>

      <input
        type="text"
        id="restaurantName"
        placeholder="Nom du restaurant"
        @input="getRestaurantByName()"
      />
    </form>

    <br />

    <button v-if="page !== 0 && restaurants !== 0" @click="pagePrecedente()">
      Précédent
    </button>
    <button v-if="page === 0" disabled>Précédent</button>

    <label> Page {{ page }} </label>

    <button
      v-if="page >= 0 && page != nbPagesTotal && restaurants != 0"
      @click="pageSuivante()"
    >
      Suivant
    </button>
    <button v-if="page === nbPagesTotal || restaurants == 0" disabled>
      Suivant
    </button>

    <br /><br />

    <div>
      <input
        type="range"
        id="sliderPage"
        min="0"
        max="100"
        value="10"
        step="5"
        @change="getRestaurantByName()"
      />
      <label for="numPageSlider"
        >{{ sliderValue }} restaurant(s) par page</label
      >
    </div>

    <br />

    <md-table v-model="restaurants" md-sort="name" md-sort-order="asc" md-card>
      <md-table-toolbar>
        <h1 class="md-title">Restaurants</h1>
      </md-table-toolbar>

      <md-table-row slot="md-table-row" slot-scope="{ item }">
        <md-table-cell md-label="Nom" md-sort-by="name">{{
          item.name
        }}</md-table-cell>
        <md-table-cell md-label="Cuisine" md-sort-by="cuisine">{{
          item.cuisine
        }}</md-table-cell>
        <md-table-cell md-label="Action">
          <router-link :to="'/details-restaurant/' + item._id"
            >[Détails Restaurant]</router-link
          >
        </md-table-cell>
      </md-table-row>
    </md-table>
  </div>
</template>

<script>
import _ from "lodash";

export default {
  name: "HelloWorld",
  data: () => ({
    restaurants: [],
    nom: "",
    cuisine: "",
    nbRestaurantsTotal: 0,
    page: 0,
    pagesize: 10,
    nbPagesTotal: 0,
    dernierePage: 0,
    sliderValue: 0,
  }),
  methods: {
    supprimerRestaurant(restaurant) {
      let restaurantASupprimer = restaurant._id;
      let url = "http://localhost:8080/api/restaurants/" + restaurantASupprimer;

      fetch(url, {
        method: "DELETE",
      })
        .then((responseJSON) => {
          responseJSON.json().then((res) => {
            // Maintenant res est un vrai objet JavaScript
            console.log("Restaurant ajouté, " + res.msg);
            // On rafraichit la vue
            this.getRestaurantsFromServer();
          });
        })
        .catch((err) => {
          console.log(err);
        });
    },
    ajouterRestaurant(event) {
      // eviter le comportement par defaut
      event.preventDefault();

      let form = event.target;
      let donneesFormulaire = new FormData(form);
      let url = "http://localhost:8080/api/restaurants";

      fetch(url, {
        method: "POST",
        body: donneesFormulaire,
      })
        .then((responseJSON) => {
          responseJSON.json().then((res) => {
            // Maintenant res est un vrai objet JavaScript
            console.log("Restaurant ajouté, " + res.msg);
            // On rafraichit la vue
            this.getRestaurantsFromServer();
          });
        })
        .catch((err) => {
          console.log(err);
        });

      this.nom = "";
      this.cuisine = "";
    },
    getColor(index) {
      return index % 2 ? "lightBlue" : "pink";
    },
    getRestaurantsFromServer() {
      this.sliderValue = document.getElementById("sliderPage").value;
      this.restaurantName = document.getElementById("restaurantName").value;
      this.pagesize = this.sliderValue;

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
          responseJSON.json().then((res) => {
            // Maintenant res est un vrai objet JavaScript
            if (this.sliderValue == 0) {
              this.restaurants = [];
            } else {
              this.restaurants = res.data;
            }

            this.nbRestaurantsTotal = res.count;
            this.nbPagesTotal = Math.round(
              this.nbRestaurantsTotal / this.pagesize
            );
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
      this.getRestaurantsFromServer();
    },
    pagePrecedente() {
      if (this.page === 0) {
        return;
      }

      this.page--;
      this.getRestaurantsFromServer();
    },
    getRestaurantByName: _.debounce(function () {
      // Prévoir le fait que l'utilisateur puisse faire une recherche sans revenir à la première page
      this.page = 0;
      this.getRestaurantsFromServer();
    }, 1000),
  },
  mounted() {
    console.log("AVANT RENDU HTML");
    this.getRestaurantsFromServer();
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.tab {
  text-align: center;
  color: #42b983;
}
</style>