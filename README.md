# Jekyll Sitemap Generator Plugin

*Jekyll plugin to silently generate a sitemaps.org compliant sitemap for your Jekyll site*

[![Build Status](https://travis-ci.org/jekyll/jekyll-sitemap.svg?branch=master)](https://travis-ci.org/jekyll/jekyll-sitemap)

## Usage

1. Add `gem 'jekyll-sitemap'` to your site's Gemfile and run `bundle`
2. Add the following to your site's `_config.yml`:

```yml
gems:
  - jekyll-sitemap
```

If all gem plugins have the same `priority`, they will be executed in the
order they are required, generally. Thus, if you have other plugins which
generate content and store that content in `site.pages`, `site.posts`, or
`site.collections`, be sure to require `jekyll-sitemap` either *after*
those other gems if you *want* the sitemap to include the generated
content, or *before* those other gems if you *don't want* the sitemap to
include the generated content from the gems. (Programming is *hard*.)

## Exclusions

If you would like to exclude specific pages/posts from the sitemap set the
sitemap flag to `false` in the front matter for the page/post.

```yml
sitemap: false
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

1. If the `sitemap.xml` doesn't generate in the `_site` folder, ensure `_config.yml` doesn't have `safe: true`. That prevents all plugins from working.
2. If the `sitemap.xml` doesn't generate in the `_site` folder, ensure that you don't have a sitemap generator plugin in your `_plugin` folder.
