import { resolve } from 'path'

import { LanguagesEnum } from "./constants";

export default defineNuxtConfig({
  alias: {
    '@assets': resolve(__dirname, '../shared_assets'),
  },
  compatibilityDate: '2024-11-01',
  css: ['~/assets/styles/main.scss'],
  devServer: {
    port: 8081,
  },
  devtools: { enabled: true },
  i18n: {
    defaultLocale: LanguagesEnum.FR,
    detectBrowserLanguage: {
      useCookie: true,
      cookieKey: 'language',
      alwaysRedirect: true,
      fallbackLocale: LanguagesEnum.FR,
    },
    locales: [LanguagesEnum.FR, LanguagesEnum.EN],
    strategy: 'no_prefix',
    vueI18n: './i18n.config.ts',
  },
  modules: ['@nuxtjs/color-mode', '@nuxtjs/i18n'],
  runtimeConfig: {
    public: {
      baseUrlApi: 'http://localhost:5000',
    },
  },
  colorMode: {
    preference: 'system',
    fallback: 'light',
  },
  vite: {
    css: {
      preprocessorOptions: {
        scss: {
          api: 'modern-compiler',
          implementation: require('sass'),
        }
      }
    }
  },
  postcss: {
    plugins: {
      autoprefixer: {},
      tailwindcss: {},
    },
  },
})
