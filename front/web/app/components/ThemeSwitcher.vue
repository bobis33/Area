<template>
  <div class="theme-switcher">
    <select v-model="$colorMode.preference" class="theme-select">
      <option value="light">{{ $t('light') }}</option>
      <option value="dark">{{ $t('dark') }}</option>
      <option value="system">{{ $t('system') }}</option>
    </select>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped lang="scss">
.theme-switcher {
  align-items: center;
  justify-content: center;
  flex-direction: column;

  .theme-select {
    margin-top: 15px;
    padding: 10px;
    font-weight: bold;
    background-color: var(--bg);
    color: var(--text-color);
    border: 1px solid var(--border-color);
    border-radius: 5px;
    font-size: 16px;
    transition: background-color 0.3s ease;

    &:hover {
      background-color: var(--dropdown-button-bg);
    }
  }
}
</style>
