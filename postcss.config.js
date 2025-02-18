const tailwindcss = require('tailwindcss');

module.exports = {
  plugins: [
    require('autoprefixer'),
    tailwindcss('./app/javascript/config/tailwind.config.js'),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
