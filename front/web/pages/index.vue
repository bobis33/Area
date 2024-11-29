<template>
  <div>
    <span>index</span>
    <slot />
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'init-auth',
})
</script>
  