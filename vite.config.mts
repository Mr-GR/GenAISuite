import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'
import path from 'path'

export default defineConfig({
  root: 'app/frontend',
  plugins: [
    RubyPlugin(),
    FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 100 }),
  ],
  build: {
    outDir: "public/vite",
    rollupOptions: {
      external: ['@hotwired/turbo-rails', '@hotwired/stimulus'],
      input: {
        application: path.resolve('app/frontend/entrypoints/application.js'),
      },
      output: {
        entryFileNames: '[name].js',
      },
    },
  },
  resolve: {
    alias: {
      '@': path.resolve('app/frontend'),
    },
  },
})

