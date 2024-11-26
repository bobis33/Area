// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  build: {
    loaders: {
      scss: {
        implementation: require('sass')
      }
    }
  },
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true }
})
