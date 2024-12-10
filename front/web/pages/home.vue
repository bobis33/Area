<template>
  <button @click="logout" class="btn-logout">{{ $t('logout') }}</button>
  <button @click="google_login" class="btn-logout">{{ $t('google_login') }}</button>
  <button @click="router.push(RoutesEnum.AREAS.toString())" class="btn-logout">{{ $t('go_to_areas') }}</button>
</template>

<script setup lang="ts">
definePageMeta({middleware: 'auth'})

import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'
import { RoutesEnum, CookiesEnum } from "~/constants";

const { showSnackbar } = useSnackbar()
const router = useRouter()
const config = useRuntimeConfig()

async function logout() {
  useCookie(CookiesEnum.TOKEN.toString()).value = ''
  await router.push(RoutesEnum.LOGIN.toString())
  showSnackbar('logoutSuccess', 'success')
}

async function google_login() {
  try {
    window.location.href = `${config.public.baseUrlApi}/auth/login/google`;
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}
</script>

<style scoped lang="scss">
.btn-logout {
  background-color: var(--error-color);
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 14px;
  transition: background-color 0.3s ease;

  &:hover {
    background-color: #dc3545;
  }
}
</style>

