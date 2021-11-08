<template>
  <div id="DetailsRestaurant">
    <h1>Détails du restaurant avec l'id {{idRestaurant}}</h1>
    <ul>
      <li>Nom : {{restaurant.name}}</li>
      <li>Cuisine : {{restaurant.cuisine}}</li>
      <li> Ville : {{restaurant.borough}}</li>
    </ul>
  </div>
</template>

<script>

export default {
  name: "DetailsRestaurant",
  props:{
  },
  computed:{
    idRestaurant(){
      return this.$route.params.id
    }
  },
  data: function() {
    return {
      restaurant : null
    }
  },
  mounted() {
    console.log("Fetch de l'id en cours...")
    let url = "http://localhost:8080/api/restaurants/" + this.idRestaurant;
    fetch(url)
    .then(reponse =>{
      return reponse.json();
    }).then(r => {
      console.log(r.restaurant.name)
      this.restaurant = r.restaurant;
    })
  }
}
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