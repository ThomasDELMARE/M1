<template>
  <div>
      <div v-if="expenses.length">
          <ol>
                <li v-for="(expense, index) in expenses" :key="index">
                    {{ expense.name }} - {{ expense.amount }}
                    <button @click="removeExpense(expense)">Remove</button>
                </li>
          </ol>

          <ol>
              <li v-for="(expense, index) in expenses" :key="index">
                  {{expense.name}} - {{expense.amount}}
              </li>
          </ol>
          <p>Total: {{total}}</p>
      </div>
      <div v-else>
          <p>Hooray! You didn't spend anything.</p>
      </div>
      <hr>
      <p>New Expense:</p>
      <form v-on:submit.prevent>
          <div>
              <input type="text" v-model="name" placeholder="What did you buy?">
          </div>
          <div>
              <input type="text" v-model="amount" placeholder="How much is it?">
          </div>
          <div>
              <button @click="addExpense()">Submit</button>
          </div>
      </form>
  </div>
</template>
 
<script>
import {db} from '../main.js'
import _ from 'lodash'
export default {
  name: 'HelloWorld',
  data: () => ({
      name: '',
      amount: '',
      total: 0,
      expenses: []
  }),
  firestore() {
      return {
          expenses: db.collection('expenses')
      }
  },
  methods: {
      addExpense() {
          this.$firestore.expenses.add({
              name: this.name,
              amount: this.amount,
              dateCreated: new Date()
          })
          this.name = ''
          this.amount = ''
      },
      removeExpense(expense){
          this.$firestore.expenses.doc(expense['.key']).delete();
      }
  },
  watch: {
      expenses() {
          this.total = _.sumBy(this.expenses, function(expense) { return parseFloat(expense.amount); });
      }
  }
}
</script>
 
<style scoped>
  div {
      margin-bottom: 20px;
  }
</style>
