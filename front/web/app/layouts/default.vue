<template>
  <div class="layout">
    <slot />
    <Snackbar v-if="snackbarMessage" :message="snackbarMessage" :type="snackbarType" />
    <footer>
    </footer>
  </div>
</template>

<script setup lang="ts">
import Snackbar from '~/components/SnackBar.vue'
import { useSnackbar } from '~/composables/useSnackBar'

const { message: snackbarMessage, type: snackbarType } = useSnackbar()
</script>
