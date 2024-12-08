<template>
  <LanguageSwitcher />
  <button @click="logout" class="btn-logout">{{ $t('logout') }}</button>
  <button @click="google_login" class="btn-logout">{{ $t('google_login') }}</button>
</template>

<script setup lang="ts">
definePageMeta({middleware: 'auth'})

import { useCookie, useRouter } from '#app'
import { useSnackbar } from '~/composables/useSnackBar'

const { showSnackbar } = useSnackbar()
const router = useRouter()
const config = useRuntimeConfig()
const tokenCookie = useCookie('token').value;

async function logout() {
  useCookie('token').value = undefined
  await router.push('/login')
  showSnackbar('logoutSuccess', 'success')
}

async function google_login() {
  try {
    const response = await fetch(`${config.public.baseUrlApi}/auth/login/google`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${tokenCookie}`,
      }
    })
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    const data = await response.json()
    console.log(data)
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
  }
}

</script>

<style scoped>
.btn-logout {
  background-color: #f44336;
  color: white;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  border-radius: 5px;
  font-size: 14px;
}

.btn-logout:hover {
  background-color: #d32f2f;
}
</style>
