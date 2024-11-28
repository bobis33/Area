<template>
  <div class="form-container">
    <h1 class="form-title">Login</h1>
    <form @submit.prevent="login">
      <div class="mb-4">
        <label for="username" class="block text-sm font-medium mb-1">Username</label>
        <input id="username" v-model="username" type="text" class="input-field" placeholder="Enter your username" />
      </div>
      <div class="mb-4">
        <label for="password" class="block text-sm font-medium mb-1">Password</label>
        <input id="password" v-model="password" type="password" class="input-field" placeholder="Enter your password" />
      </div>
      <button type="submit" class="btn-primary">Login</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from '#app'

const config = useRuntimeConfig()
const router = useRouter()

const username = ref('')
const password = ref('')
const errorMessage = ref('')

async function login() {
  try {
    const response = await fetch(`${config.public.baseUrlApi}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        username: username.value,
        password: password.value,
      }),
    })

    if (!response.ok) {
      const errorData = await response.json()
      errorMessage.value = errorData.detail || 'Login failed'
      return
    }

    const data = await response.json()
    const token = data.token
    if (token) {
      localStorage.setItem('token', token)
      alert('Login successful!')
      await router.push({name: 'home'})
      errorMessage.value = ''
    }
  } catch (error) {
    errorMessage.value = 'An error occurred. Please try again later.'
    console.error(error)
  }
}
</script>

<style lang="scss" scoped>
@use "~/assets/styles/forms.scss" as *;
</style>