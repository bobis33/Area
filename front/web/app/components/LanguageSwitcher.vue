<template>
  <div class="select">
    <select v-model="languageCookie" @change="updateLanguage" class="language-select" :aria-label="$t('changeLanguage')">
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
</style>
