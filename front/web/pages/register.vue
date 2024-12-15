<template>
  <div class="form-container">
    <img src="@assets/icon.png" alt="AREA icon" class="auth-logo" />
    <h1 class="form-title">{{ $t('register') }}</h1>
    <form @submit.prevent="handleRegister">
      <div class="mb-4">
        <label for="username" class="label">{{ $t('username') }}</label>
        <input id="username" v-model="username" type="text" class="input-field" :placeholder="$t('username')" />
      </div>
      <div class="mb-4">
        <label for="password" class="label">{{ $t('password') }}</label>
        <input id="password" v-model="password" type="password" class="input-field" :placeholder="$t('password')" />
      </div>
      <div class="mb-4">
        <label for="confirmPassword" class="label">{{ $t('passwordConfirmation') }}</label>
        <input id="confirmPassword" v-model="confirmPassword" type="password" class="input-field" :placeholder="$t('passwordConfirmation')"
        />
      </div>
      <button type="submit" class="btn-primary w-full mt-8">{{ $t('register') }}</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ $t(errorMessage) }}</p>
    <div class="text-link mt-4">
      <p>{{ $t('alreadyHaveAccount') }}
        <button @click="router.push(RoutesEnum.LOGIN.toString())" class="btn-link">{{ $t('loginHere') }}</button>
      </p>
    </div>
  </div>
</template>


<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'
import { RoutesEnum } from "~/config/constants";
import { AuthRepository } from "~/infrastructure/repositories/AuthRepository";
import { RegisterUser } from '~/domain/use-cases/RegisterUser'

const username = ref('')
const password = ref('')
const confirmPassword = ref('')
const errorMessage = ref('')
const router = useRouter()
const { showSnackbar } = useSnackbar()

const handleRegister = async () => {
  try {
    if (!username.value || !password.value || !confirmPassword.value) {
      errorMessage.value = 'fillInAllFields'
      return
    }
    if (password.value !== confirmPassword.value) {
      errorMessage.value = 'passwordMismatch'
      return
    }

    const token = await new RegisterUser(new AuthRepository()).execute({ username: username.value, password: password.value })
    if (token) {
      showSnackbar('registerSuccess', 'success')
      await router.push(RoutesEnum.LOGIN.toString());
    }
  } catch (error: any) {
    errorMessage.value = error.message || 'anErrorOccurred'
  }
}
</script>

<style scoped lang="scss">
@use 'assets/styles/buttons' as *;
@use 'assets/styles/errors' as *;
@use 'assets/styles/forms' as *;
@use 'assets/styles/logo' as *;
</style>
