<template>
  <div class="form-container">
    <img src="@assets/images/icon.png" alt="AREA icon" class="register-logo" />
    <h1 class="form-title">Register</h1>
    <form @submit.prevent="register">
      <div class="mb-4">
        <label for="username" class="block text-sm font-medium mb-1">Username</label>
        <input
            id="username"
            v-model="username"
            type="text"
            class="input-field"
            placeholder="Enter your username"
        />
      </div>
      <div class="mb-4">
        <label for="password" class="block text-sm font-medium mb-1">Password</label>
        <input
            id="password"
            v-model="password"
            type="password"
            class="input-field"
            placeholder="Enter your password"
        />
      </div>
      <div class="mb-4">
        <label for="confirmPassword" class="block text-sm font-medium mb-1">Confirm Password</label>
        <input
            id="confirmPassword"
            v-model="confirmPassword"
            type="password"
            class="input-field"
            placeholder="Confirm your password"
        />
      </div>
      <button type="submit" class="btn-primary">Register</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
    <div class="login-link mt-4">
      <p>Already have an account?
        <button @click="router.push({ name: 'login'})" class="btn-link">Login here</button>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">

import { ref } from 'vue'
import { useCookie, useRouter } from '#app'

definePageMeta({
  middleware: 'auth',
})

const config = useRuntimeConfig()
const router = useRouter()
const tokenCookie = useCookie('token', { path: '/', maxAge: 60 * 60 * 24 * 7 })

const username = ref('')
const password = ref('')
const confirmPassword = ref('')
const errorMessage = ref('')

async function register() {
  try {
    if (password.value !== confirmPassword.value) {
      errorMessage.value = "Passwords do not match"
      return
    }

    const response = await fetch(`${config.public.baseUrlApi}/auth/register`, {
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
      errorMessage.value = errorData.detail || 'Registration failed'
      return
    }

    const data = await response.json()
    const token = data.token
    if (token) {
      tokenCookie.value = token
      alert('Registration successful!')
      await router.push({name: 'login'})
      }
  } catch (error) {
    errorMessage.value = 'An error occurred. Please try again later.'
    console.error(error)
  }
}
</script>

<style lang="scss" scoped>
@use "~/assets/styles/forms.scss" as *;
@use "~/assets/styles/buttons.scss" as *;
@use "~/assets/styles/errors.scss" as *;

.register-logo {
  display: block;
  width: 125px;
  height: 125px;
  margin: 0 auto 20px;
}
</style>
