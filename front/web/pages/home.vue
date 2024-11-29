<template>
  <div>
    <span>Homepage</span>
    <slot />
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth',
})
</script>