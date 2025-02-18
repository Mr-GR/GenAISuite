import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 100 }),
  ],
  build: {
    rollupOptions: {
      external: ['@hotwired/turbo-rails', '@hotwired/stimulus'],
      input: {
        application: 'app/frontend/entrypoints/application.js',
      },
    },
  },
  resolve: {
    alias: {
      '@': '/app/frontend',
    },
  },
})
