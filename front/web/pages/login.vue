<template>
  <div class="form-container">
    <img src="@assets/images/icon.png" alt="Area icon" class="login-logo" />
    <h1 class="form-title">{{ $t('login') }}</h1>
    <form @submit.prevent="handleSubmit">
      <div class="mb-4">
        <label for="username" class="block text-sm font-medium mb-1">{{ $t('username') }}</label>
        <input id="username" v-model="username" type="text" class="input-field" :placeholder="$t('username')" />
      </div>
      <div class="mb-4">
        <label for="password" class="label">{{ $t('password') }}</label>
        <input id="password" v-model="password" type="password" class="input-field" :placeholder="$t('password')" />
      </div>
      <button type="submit" class="btn-primary">{{ $t('login') }}</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ $t(errorMessage) }}</p>
    <div class="register-link mt-4">
      <p>{{ $t('noAccount') }}
        <button @click="router.push(RoutesEnum.REGISTER.toString())" class="btn-link">{{ $t('registerHere') }}</button>
      </p>
    </div>
  </div>
</template>


<script setup lang="ts">
definePageMeta({middleware: 'auth'})
import { ref } from 'vue'
import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'
import { loginUser } from '~/domain/use-cases/loginUser'
import { RoutesEnum } from "~/constants";

const username = ref('')
const password = ref('')
const errorMessage = ref('')
const tokenCookie = useCookie('token', { path: '/', maxAge: 60 * 60 * 24 * 7 })
const router = useRouter()
const { showSnackbar } = useSnackbar()

async function handleSubmit() {
  try {
    if (!username.value || !password.value) {
      errorMessage.value = 'fillAllFields'
      return
    }
    tokenCookie.value = await loginUser({ email: username.value, password: password.value })
    showSnackbar('loginSuccess', 'success')
    await router.push('/home')
  } catch (error: any) {
    errorMessage.value = error.message
  }
}
</script>

<style lang="scss" scoped>
@use "assets/styles/forms" as *;
@use "assets/styles/buttons" as *;
@use "assets/styles/errors" as *;

.login-logo {
  display: block;
  width: 125px;
  height: 125px;
  margin: 0 auto 20px;
}

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

.register-link {
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
