import { LanguagesEnum } from './config/constants'

export default defineNuxtConfig({
  colorMode: {
    preference: 'system',
    fallback: 'light',
  },
  compatibilityDate: '2024-11-01',
  css: ['~/assets/styles/main.scss'],
  devServer: {
    port: Number(process.env.PORT),
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
      baseUrlApi: process.env.API_URL,
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
