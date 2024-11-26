<template>
    <div>
      <h1>Login</h1>
      <form @submit.prevent="login">
        <div>
          <label for="username">Username</label>
          <input id="username" v-model="username" type="text" />
        </div>
        <div>
          <label for="password">Password</label>
          <input id="password" v-model="password" type="password" />
        </div>
        <button type="submit">Login</button>
      </form>
      <p v-if="errorMessage">{{ errorMessage }}</p>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { useFetch } from '#app'
  
  const username = ref('')
  const password = ref('')
  const errorMessage = ref('')
  
  async function login() {
    const { data, error } = await useFetch('localhost:5000/login', {
      method: 'POST',
      body: {
        username: username.value,
        password: password.value,
      },
    })
  
    if (error.value) {
      errorMessage.value = error.value.data?.detail || 'Login failed'
      return
    }
  
    const token = data.value?.token
    if (token) {
      localStorage.setItem('token', token) // Store token
      alert('Login successful!')
    }
  }
  </script>
  