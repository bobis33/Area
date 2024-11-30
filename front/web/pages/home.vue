<template>
  <span>Homepage</span>
  <button @click="logout" class="btn-logout">Logout</button>
  <slot />
</template>

<script setup lang="ts">

import { useCookie, useRouter } from '#app'

import { useSnackbar } from '~/composables/useSnackBar'

const router = useRouter()
const { showSnackbar } = useSnackbar()

function logout() {
  useCookie('token').value = undefined
  showSnackbar('Logout successful', 'success')
  router.push({ name: 'login' })
}

definePageMeta({
  middleware: 'auth',
})

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
