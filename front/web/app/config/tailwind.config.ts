import type { Config } from 'tailwindcss'

export default <Partial<Config>>{
  content: [
    './components/**/*.{vue,ts}',
    './composables/**/*.{vue,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './*.vue',
    './nuxt.config.ts'
  ],
  theme: {
    extend: {}
  },
  plugins: []
}
