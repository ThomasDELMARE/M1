import Vue from 'vue'
import App from './App.vue'
import firebase from 'firebase'
import 'firebase/firestore'
import VueFirestore from 'vue-firestore'

// Pour se connecter à Firestore
firebase.initializeApp({
  // Your web app's Firebase configuration
  apiKey: "AIzaSyAgpxAL0BI4cvEWE2uTXba8IKqPdbbCgr8",
  authDomain: "miage-tp1.firebaseapp.com",
  projectId: "miage-tp1",
  storageBucket: "miage-tp1.appspot.com",
  messagingSenderId: "436121493848",
  appId: "1:436121493848:web:22cb3e87603a538d2a852d"
});
 
export const db = firebase.firestore();
 
// configuration globale
Vue.use(VueFirestore)
Vue.config.productionTip = false
 
// démarre l'affichage
new Vue({
  render: h => h(App),
}).$mount('#app')