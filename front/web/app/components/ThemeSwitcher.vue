<template>
  <div class="select">
    <select v-model="$colorMode.preference" class="theme-select" :aria-label="$t('changeTheme')">
      <option value="light">{{ $t('light') }}</option>
      <option value="dark">{{ $t('dark') }}</option>
      <option value="system">{{ $t('system') }}</option>
    </select>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped lang="scss">

</style>
