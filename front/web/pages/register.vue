<template>
  <div class="form-container">
    <img src="@assets/images/icon.png" alt="AREA icon" class="register-logo" />
    <h1 class="form-title">{{ $t('register') }}</h1>
    <form @submit.prevent="register">
      <div class="mb-4">
        <label for="email" class="label">{{ $t('email') }}</label>
        <input id="email" v-model="email" type="text" class="input-field" :placeholder="$t('email')" />
      </div>
      <div class="mb-4">
        <label for="password" class="label">{{ $t('password') }}</label>
        <input id="password" v-model="password" type="password" class="input-field" :placeholder="$t('password')" />
      </div>
      <div class="mb-4">
        <label for="confirmPassword" class="label">{{ $t('passwordConfirmation') }}</label>
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
      <p>
        {{ $t('alreadyHaveAccount') }}
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

.form-container {
  max-width: 400px;
  margin: 0 auto;
  background-color: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 0.5rem;
  padding: 2rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  color: var(--text-color);
}

.register-logo {
  display: block;
  width: 125px;
  height: 125px;
  margin: 0 auto 20px;
}

.form-title {
  font-size: 1.5rem;
  font-weight: bold;
  text-align: center;
  margin-bottom: 1.5rem;
  color: var(--color-primary);
}

.label {
  display: block;
  color: var(--text-color);
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.input-field {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 0.375rem;
  background-color: var(--bg);
  color: var(--text-color);
  font-size: 1rem;

  &:focus {
    border-color: var(--color-primary);
    outline: none;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.3);
  }
}

.error-message {
  color: var(--error-color);
  font-size: 0.875rem;
  margin-top: 1rem;
  text-align: center;
}

.login-link {
  text-align: center;

  .btn-link {
    color: var(--link-color);
    text-decoration: underline;
    background: none;
    border: none;
    font-size: 1rem;
    cursor: pointer;

    &:hover {
      color: var(--link-hover-color);
    }
  }
}

</style>
