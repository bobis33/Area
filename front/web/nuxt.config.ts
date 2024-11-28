// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  runtimeConfig: {
    public: {
      baseUrlApi: 'http://localhost:5000',
    },
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
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  css: ['~/assets/styles/main.scss'],

  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
})
