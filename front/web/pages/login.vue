<template>
  <LanguageSwitcher />
  <div class="form-container">
    <img src="@assets/images/icon.png" alt="Area icon" class="login-logo" />
    <h1 class="form-title">{{ $t('login') }}</h1>
    <form @submit.prevent="login">
      <div class="mb-4">
        <label for="username" class="block text-sm font-medium mb-1">{{ $t('email') }}</label>
        <input id="username" v-model="email" type="text" class="input-field" :placeholder="$t('enterEmail')" />
      </div>
      <div class="mb-4">
        <label for="password" class="block text-sm font-medium mb-1">{{ $t('password') }}</label>
        <input id="password" v-model="password" type="password" class="input-field" :placeholder="$t('enterPassword')" />
      </div>
      <button type="submit" class="btn-primary">{{ $t('login') }}</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ $t(errorMessage) }}</p>
    <div class="register-link mt-4">
      <p>{{ $t('noAccount') }}
        <button @click="router.push('/register')" class="btn-link">{{ $t('registerHere') }}</button>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({middleware: 'auth'})

import { ref } from 'vue'
import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'

const config = useRuntimeConfig()
const tokenCookie = useCookie('token', { path: '/', maxAge: 60 * 60 * 24 * 7 })
const router = useRouter()
const { showSnackbar } = useSnackbar()

const email = ref('')
const password = ref('')
const errorMessage = ref('')

async function login() {
  try {
    if (!email.value || !password.value) {
      errorMessage.value = 'fillInAllFields'
      return
    }
    if (!email.value.includes('@') || !email.value.includes('.')) {
      errorMessage.value = 'enterEmailValid'
      return
    }

    const response = await fetch(`${config.public.baseUrlApi}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: email.value,
        password: password.value,
      }),
    })

    if (!response.ok) {
      const errorData = await response.json()
      errorMessage.value = 'invalidCredentials'
      console.error(errorData)
      return
    }

    const data = await response.json()
    const token = data.token
    if (token) {
      tokenCookie.value = token
      await router.push('/home')
      showSnackbar('loginSuccess', 'success')
    }
  } catch (error) {
    errorMessage.value = 'anErrorOccurred'
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