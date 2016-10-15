require "fileutils"

module Jekyll
  class JekyllSitemap < Jekyll::Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.pages << sitemap unless sitemap_exists?
    end

    private

    INCLUDED_EXTENSIONS = %W(
      .htm
      .html
      .xhtml
      .pdf
    ).freeze

    # Matches all whitespace that follows
    #   1. A '>' followed by a newline or
    #   2. A '}' which closes a Liquid tag
    # We will strip all of this whitespace to minify the template
    MINIFY_REGEX = %r!(?<=>\n|})\s+!

    # Array of all non-jekyll site files with an HTML extension
    def static_files
      @site.static_files.select { |file| INCLUDED_EXTENSIONS.include? file.extname }
    end

    # Path to sitemap.xml template file
    def source_path
      File.expand_path "../sitemap.xml", File.dirname(__FILE__)
    end

    # Destination for sitemap.xml file within the site source directory
    def destination_path
      @site.in_dest_dir("sitemap.xml")
    end

    def sitemap
      site_map = PageWithoutAFile.new(@site, File.dirname(__FILE__), "", "sitemap.xml")
      site_map.content = File.read(source_path).gsub(MINIFY_REGEX, "")
      site_map.data["layout"] = nil
      site_map.data["static_files"] = static_files.map(&:to_liquid)
      site_map
    end

    # Checks if a sitemap already exists in the site source
    def sitemap_exists?
      if @site.respond_to?(:in_source_dir)
        File.exist? @site.in_source_dir("sitemap.xml")
      else
        File.exist? Jekyll.sanitized_path(@site.source, "sitemap.xml")
      end
    end
  end
end
