<template>
  <div class="language-switcher">
    <button
        v-for="lang in ['en', 'fr']"
        :key="lang"
        @click="changeLanguage(lang)"
        :class="{ active: locale === lang }"
    >
      {{ lang.toUpperCase() }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { useCookie } from '#app'

const { locale } = useI18n()

const languageCookie = useCookie('language')

if (languageCookie.value) {
  locale.value = languageCookie.value
}

const changeLanguage = (lang) => {
  locale.value = lang
  languageCookie.value = lang
}
</script>

<style scoped lang="scss">
.language-switcher {
  display: flex;

  button {
    padding: 5px 10px;
    border: 1px solid var(--border-color);
    background-color: var(--button-bg);
    color: var(--text-on-primary);
    cursor: pointer;
    border-radius: 5px;
    font-weight: bold;
    transition: background-color 0.3s ease;

    &:hover {
      background-color: var(--button-bg-hover);
    }

    &.active {
      background-color: var(--color-primary);
      color: var(--reverse-border-color);
      border-color: var(--reverse-border-color);;
    }
  }
}
</style>

