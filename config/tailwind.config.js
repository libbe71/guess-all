const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  future: {
    hoverOnlyWhenSupported: true,
  },
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
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
