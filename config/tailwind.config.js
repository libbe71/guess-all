const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  darkMode: 'class',
  future: {
    hoverOnlyWhenSupported: true,
  },
  safelist: [
    'fixed', 'inset-0', 'bg-gray-600', 'bg-opacity-50', 'overflow-y-auto', 'h-full',
    'w-full', 'relative', 'top-1/4', 'mx-auto', 'p-5', 'border', 'w-11/12', 'sm:w-1/3',
    'bg-white', 'rounded-lg', 'shadow-lg', 'bg-green-500', 'hover:bg-green-700',
    'bg-red-500', 'hover:bg-red-700', 'text-white', 'font-bold', 'py-2', 'px-4', 'rounded',
  ],
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/assets/javascript/**/*.js',
    './app/views/**/*',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },

      colors: {
        transparent: 'transparent',
        current: 'currentColor',
        black: '#000000',
        'primary': {
          default: '#dc2626',
        },
        'secondary':{
          default: '#84cc16',
        },
        'tertiary':{
          default: '#7c3aed',
        },
        'success':{
          default: '#84cc16',
        },
        'warning':{
          default: '#fde047',
        },
        'error':{
          default: '#ef5350',
        } 
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
