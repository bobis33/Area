<template>
  <div class="form-container">
    <img src="@assets/images/icon.png" alt="Area icon" class="login-logo" />
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
    <div class="register-link mt-4">
      <p>Don't have an account?
        <button @click="router.push({name: 'register'})" class="btn-link">Register here</button>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">

import { ref } from 'vue'
import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'

definePageMeta({
  middleware: 'auth',
})

const config = useRuntimeConfig()
const router = useRouter()
const tokenCookie = useCookie('token', { path: '/', maxAge: 60 * 60 * 24 * 7 })

const username = ref('')
const password = ref('')
const errorMessage = ref('')
const { showSnackbar } = useSnackbar()


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
      console.error(errorData)
      return
    }

    const data = await response.json()
    const token = data.token
    if (token) {
      tokenCookie.value = token
      showSnackbar('Login successful', 'success')
      await router.push({name: 'home'})
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

.login-logo {
  display: block;
  width: 125px;
  height: 125px;
  margin: 0 auto 20px;
}
</style>