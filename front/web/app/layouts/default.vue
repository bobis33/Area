<template>
  <div class="layout">
    <Header />
    <slot />
    <Snackbar v-if="snackbarMessage" :message="snackbarMessage" :type="snackbarType" />
    <footer>
    </footer>
  </div>
</template>

<script setup lang="ts">
import Snackbar from '~/components/SnackBar.vue'
import { useSnackbar } from '~/composables/useSnackBar'
import Header from '~/components/Header.vue'

const { message: snackbarMessage, type: snackbarType } = useSnackbar()
</script>
