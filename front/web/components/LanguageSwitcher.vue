<template>
  <div>
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

<style scoped>
.language-switcher {
  display: flex;
  gap: 10px;
}

button {
  padding: 5px 10px;
  border: 1px solid #ccc;
  background-color: #f9f9f9;
  cursor: pointer;
  border-radius: 5px;
}

button.active {
  background-color: #007bff;
  color: white;
  border-color: #007bff;
}
</style>
