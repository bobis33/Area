<template>
  <div class="error-container">
    <h1 class="error-title">Oops! Something went wrong.</h1>
    <p class="error-message-grey">
      <strong>Error Code:</strong> {{ errorCode }} <br />
      <strong>Message:</strong> {{ errorMessage }}
    </p>
    <router-link to="/" class="error-link">Go back to home</router-link>
  </div>
</template>

<script setup lang="ts">

const error = useError()

const errorCode = error.value?.statusCode || 'Unknown'
const errorMessage = error.value?.statusMessage || 'An unknown error occurred. Please try again later.'
</script>

<style lang="scss" scoped>
@use "~/assets/styles/errors.scss" as *;
</style>
