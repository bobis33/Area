import { resolve } from 'path'

export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  css: ['~/assets/styles/main.scss'],
  alias: {
    '@assets': resolve(__dirname, '../assets'),
  },
  devServer: {
    port: 8081,
  },
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
          implementation: require('sass'),
          api: 'modern-compiler',
        }
      }
    }
  },
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  i18n: {
    locales: ['en', 'fr'],
    defaultLocale: 'fr',
    vueI18n: './i18n.config.ts',
},
  modules: ['@nuxtjs/i18n', '@nuxtjs/color-mode'],
})
