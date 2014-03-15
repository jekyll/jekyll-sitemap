Gem::Specification.new do |s|
  s.name        = "jekyll-sitemap"
  s.summary     = "Automatically generate a sitemap.xml for your Jekyll site."
  s.version     = "0.1.0"
  s.authors     = ["GitHub, Inc."]
  s.email       = "support@github.com"
  s.homepage    = "https://github.com/github/jekyll-sitemap"
  s.licenses    = ["MIT"]

  s.files         = Dir["lib/*"]
  s.require_paths = ["lib"]

  s.add_dependency "jekyll", "~> 1.4.3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
