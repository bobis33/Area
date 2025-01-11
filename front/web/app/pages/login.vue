<template>
  <div class="form-container">
    <ImageComponent fileName="area.png" altText="area" class="auth-logo" />
    <h1 class="form-title">{{ $t('login') }}</h1>
    <form @submit.prevent="handleSubmit">
      <div class="mb-4">
        <label for="username" class="label">{{ $t('username') }}</label>
        <input id="username" v-model="username" type="text" class="input-field" :placeholder="$t('username')" />
      </div>
      <div class="mb-4">
        <label for="password" class="label">{{ $t('password') }}</label>
        <input id="password" v-model="password" type="password" class="input-field" :placeholder="$t('password')" />
      </div>
      <button type="submit" class="btn-primary w-full mt-8">{{ $t('login') }}</button>
    </form>
    <p v-if="errorMessage" class="error-message">{{ $t(errorMessage) }}</p>
    <div class="text-link mt-4">
      <p>{{ $t('noAccount') }}
        <button @click="router.push(RoutesEnum.REGISTER.toString())" class="btn-link">{{ $t('registerHere') }}</button>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import {ref} from 'vue'
import {useCookie, useRouter} from '#app'
import ImageComponent from '~/components/Assets.vue'

import { useSnackbar } from '~/composables/useSnackBar'
import { LoginUser } from '~/domain/use-cases/auth'
import { CookiesEnum, RoutesEnum } from '~/config/constants'
import { AuthRepository } from '~/infrastructure/repositories/AuthRepository'

const username = ref('')
const password = ref('')
const errorMessage = ref('')
const tokenCookie = useCookie(CookiesEnum.TOKEN.toString(), { path: '/', maxAge: 60 * 60 * 24 * 7 })
const router = useRouter()
const { showSnackbar } = useSnackbar()

async function handleSubmit() {
  try {
    if (!username.value || !password.value) {
      errorMessage.value = 'fillInAllFields'
      return
    }
    tokenCookie.value = await new LoginUser(new AuthRepository()).execute({ username: username.value, password: password.value })
    showSnackbar('loginSuccess', 'success')
    await router.push(RoutesEnum.HOME.toString())
  } catch (error: any) {
    errorMessage.value = error.message
  }
}
</script>

<style scoped lang="scss">
@use 'assets/styles/buttons' as *;
@use 'assets/styles/errors' as *;
@use 'assets/styles/forms' as *;
@use 'assets/styles/logo' as *;
</style>
