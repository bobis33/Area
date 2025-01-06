<template>
  <button @click="logout" class="btn-logout m-5">{{ $t('logout') }}</button>
  <button @click="googleLogin" class="btn-primary m-5">{{ $t('googleLogin') }}</button>
  <button @click="router.push(RoutesEnum.AREAS.toString())" class="btn-primary m-5">{{ $t('myAreas') }}</button>
</template>

<script setup lang="ts">
import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'
import { RoutesEnum, CookiesEnum } from '~/config/constants'

const { showSnackbar } = useSnackbar()
const router = useRouter()
const config = useRuntimeConfig()

async function logout() {
  useCookie(CookiesEnum.TOKEN.toString()).value = null
  await router.push(RoutesEnum.LOGIN.toString())
  showSnackbar('logoutSuccess', 'success')
}

async function googleLogin() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/google`;
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}
</script>

<style scoped lang="scss">
@use 'assets/styles/buttons' as *;

.btn-logout {
  background-color: var(--error-color);
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 1.125rem;
  transition: background-color 0.3s ease;

  &:hover {
    background-color: #dc3545;
  }
}
</style>
