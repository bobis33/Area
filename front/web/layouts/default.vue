<template>
  <div>
    <header>
      <span>Header</span>
    </header>
    <slot />
    <Snackbar v-if="snackbarMessage" :message="snackbarMessage" :type="snackbarType" />
    <footer>
      <span>Footer</span>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { useSnackbar } from '~/composables/useSnackBar'
import Snackbar from '~/components/SnackBar.vue'

const { message: snackbarMessage, type: snackbarType } = useSnackbar()
</script>

