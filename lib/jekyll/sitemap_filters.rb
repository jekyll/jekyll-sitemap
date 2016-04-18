require 'addressable/uri'

module Jekyll
  module SitemapFilters
    def normalize_url(input)
      Addressable::URI.parse(input).normalize.to_s
    end
  end
end
Liquid::Template.register_filter(Jekyll::SitemapFilters)
