<template>
  <LanguageSwitcher />
  <div class="form-container">
    <img src="@assets/images/icon.png" alt="AREA icon" class="register-logo" />
    <h1 class="form-title">{{ $t('register') }}</h1>
    <form @submit.prevent="register">
      <div class="mb-4">
        <label for="email" class="block text-sm font-medium mb-1">{{ $t('email') }}</label>
        <input id="email" v-model="email" type="text" class="input-field" :placeholder="$t('email')"/>
      </div>
      <div class="mb-4">
        <label for="password" class="block text-sm font-medium mb-1">{{ $t('password') }}</label>
        <input
            id="password"
            v-model="password"
            type="password"
            class="input-field"
            :placeholder="$t('password')"
        />
      </div>
      <div class="mb-4">
        <label for="confirmPassword" class="block text-sm font-medium mb-1">{{ $t('passwordConfirmation') }}</label>
        <input
            id="confirmPassword"
            v-model="confirmPassword"
            type="password"
            class="input-field"
            :placeholder="$t('passwordConfirmation')"
        />
      </div>
      <button type="submit" class="btn-primary">{{ $t('register') }}</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ $t(errorMessage) }}</p>
    <div class="login-link mt-4">
      <p>{{ $t('alreadyHaveAccount') }}
        <button @click="router.push('login')" class="btn-link">{{ $t('loginHere') }}</button>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({middleware: 'auth'})

import { ref } from 'vue'

import { useSnackbar } from "~/composables/useSnackBar";

const config = useRuntimeConfig()
const router = useRouter()
const { showSnackbar } = useSnackbar()

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const errorMessage = ref('')

async function register() {
  try {
    if (!email.value || !password.value || !confirmPassword.value) {
      errorMessage.value = 'fillInAllFields'
      return
    }
    if (!email.value.includes('@') || !email.value.includes('.')) {
      errorMessage.value = 'enterEmailValid'
      return
    }
    if (password.value.length < 8) {
      errorMessage.value = 'passwordLength'
      return
    }
    if (password.value !== confirmPassword.value) {
      errorMessage.value = 'passwordMismatch'
      return
    }

    const response = await fetch(`${config.public.baseUrlApi}/auth/register`, {
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
      errorMessage.value = 'registerError'
      console.log(errorData)
      return
    }

    const data = await response.json()
    const token = data.token
    if (token) {
      await router.push('/login')
      showSnackbar('registerSuccess', 'success')
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

.register-logo {
  display: block;
  width: 125px;
  height: 125px;
  margin: 0 auto 20px;
}
</style>
