import { resolve } from 'path'

import { LanguagesEnum } from './config/constants'

export default defineNuxtConfig({
  alias: {
    '@assets': resolve(__dirname, '../../../assets'),
  },
  colorMode: {
    preference: 'system',
    fallback: 'light',
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
      alwaysRedirect: true,
      cookieKey: 'language',
      fallbackLocale: LanguagesEnum.FR,
      useCookie: true,
    },
    locales: [LanguagesEnum.FR, LanguagesEnum.EN],
    strategy: 'no_prefix',
    vueI18n: './config/i18n.config.ts',
  },
  modules: ['@nuxtjs/color-mode', '@nuxtjs/i18n'],
  postcss: {
    plugins: {
      autoprefixer: {},
      tailwindcss: { config: './config/tailwind.config.ts' },
    },
  },
  runtimeConfig: {
    public: {
      baseUrlApi: 'http://localhost:8080',
    },
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
})
