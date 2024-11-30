// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: true },
  css: ['~/assets/styles/main.scss'],
  devServer: {
    port: 8081,
  },
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
  postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
})
