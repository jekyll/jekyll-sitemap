# Jekyll Sitemap Generator Plugin

*Jekyll plugin to silently generate a sitemaps.org compliant sitemap for your Jekyll site*

[![Build Status](https://travis-ci.org/jekyll/jekyll-sitemap.svg?branch=master)](https://travis-ci.org/jekyll/jekyll-sitemap)

## Usage

1. Add `gem 'jekyll-sitemap'` to your site's Gemfile
2. Add the following to your site's `_config.yml`:

```yml
gems:
  - jekyll-sitemap
```

## Developing locally

Use `script/bootstrap` to bootstrap your local development environment.

Use `script/console` to load a local IRB console with the Gem.

## Testing

1. `script/bootstrap`
2. `script/cibuild`

## Contributing

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request

## Issues
1. If the `sitemap.xml` doesn't generate in the `\_site` folder ensure `\_config.yml` doesn't have `safe: true`. That prevents all plugins from working.

