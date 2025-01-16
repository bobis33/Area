<template>
  <div class="language-switcher">
    <select v-model="languageCookie" @change="updateLanguage" class="language-select">
      <option
          v-for="lang in Object.values(LanguagesEnum)"
          :key="lang"
          :value="lang"
      >
        {{ lang.toUpperCase() }}
      </option>
    </select>
  </div>
</template>

<script setup lang="ts">
import { useCookie } from '#app'
import { CookiesEnum, LanguagesEnum } from '~/config/constants'
import { useI18n } from 'vue-i18n'

const { setLocale } = useI18n()
const languageCookie = useCookie(CookiesEnum.LANGUAGE)

const updateLanguage = () => {
  if (languageCookie.value) {
    setLocale(languageCookie.value as LanguagesEnum)
  }
}

if (languageCookie.value) {
  setLocale(languageCookie.value as LanguagesEnum)
}
</script>

<style scoped lang="scss">
.language-switcher {
  align-items: center;
  justify-content: center;
  flex-direction: column;

  .language-select {
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
