<template>
    <div class="language-switcher">
      <button
          v-for="lang in [LanguagesEnum.EN.toString(), LanguagesEnum.FR.toString()]"
          :key="lang"
          @click="changeLanguage(lang)"
          :class="{ active: lang === languageCookie?.toString() }"
      >
        {{ lang.toUpperCase() }}
      </button>
    </div>
</template>

<script setup lang="ts">
import { useCookie } from '#app'

import { LanguagesEnum } from "~/constants";

const { setLocale } = useI18n()
const languageCookie = useCookie('language')

const changeLanguage = (lang: string) => {
  setLocale(languageCookie.value as LanguagesEnum.EN | LanguagesEnum.FR)
  languageCookie.value = lang
}

if (languageCookie.value) {
  setLocale(languageCookie.value as LanguagesEnum.EN | LanguagesEnum.FR)
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

