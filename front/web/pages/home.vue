<template>
  <LanguageSwitcher />
  <button @click="logout" class="btn-logout">{{ $t('logout') }}</button>
</template>

<script setup lang="ts">
definePageMeta({middleware: 'auth'})

import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'

const { showSnackbar } = useSnackbar()
const router = useRouter()

async function logout() {
  useCookie('token').value = undefined
  await router.push('/login')
  showSnackbar('logoutSuccess', 'success')
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
