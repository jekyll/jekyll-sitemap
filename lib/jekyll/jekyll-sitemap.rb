# frozen_string_literal: true

require "fileutils"

module Jekyll
  class JekyllSitemap < Jekyll::Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site

      @config = site.config["jekyll_sitemap"]
      @config = {} unless @config.is_a?(Hash) && @config["index"].is_a?(Hash)

      @index_filename = @config.dig("index", "filename") || "sitemap_index.xml"
      @index_entries =  @config.dig("index", "linked_sitemaps")

      if @index_entries.is_a?(Array)
        @priority_sitemap = @index_filename
        @site.pages << sitemap_index unless file_exists?("sitemap_index.xml")
      else
        @priority_sitemap = "sitemap.xml"
      end

      @site.pages << sitemap unless file_exists?("sitemap.xml")
      @site.pages << robots unless file_exists?("robots.txt")
    end

    private

    INCLUDED_EXTENSIONS = %w(
      .htm
      .html
      .xhtml
      .pdf
      .xml
    ).freeze

    # Matches all whitespace that follows
    #   1. A '>' followed by a newline or
    #   2. A '}' which closes a Liquid tag
    # We will strip all of this whitespace to minify the template
    MINIFY_REGEX = %r!(?<=>\n|})\s+!.freeze

    # Array of all non-jekyll site files with an HTML extension
    def static_files
      @site.static_files.select { |file| INCLUDED_EXTENSIONS.include? file.extname }
    end

    # Path to sitemap.xml template file
    def source_path(file = "sitemap.xml")
      File.expand_path "../#{file}", __dir__
    end

    # Destination for sitemap.xml file within the site source directory
    def destination_path(file = "sitemap.xml")
      @site.in_dest_dir(file)
    end

    def sitemap_index
      index = PageWithoutAFile.new(@site, __dir__, "", "sitemap_index.xml")
      index.content = File.read(source_path("sitemap_index.xml")).gsub(MINIFY_REGEX, "")
      index.data["layout"] = nil
      index.data["permalink"] = "/#{@index_filename}"
      index.data["linked_sitemaps"] = @index_entries
      index.data["xsl"] = file_exists?("sitemap_index.xsl")
      index
    end

    def sitemap
      site_map = PageWithoutAFile.new(@site, __dir__, "", "sitemap.xml")
      site_map.content = File.read(source_path).gsub(MINIFY_REGEX, "")
      site_map.data["layout"] = nil
      site_map.data["static_files"] = static_files.map(&:to_liquid)
      site_map.data["xsl"] = file_exists?("sitemap.xsl")
      site_map
    end

    def robots
      robots = PageWithoutAFile.new(@site, __dir__, "", "robots.txt")
      robots.content = File.read(source_path("robots.txt"))
      robots.data["layout"] = nil
      robots.data["priority_sitemap"] = @priority_sitemap
      robots
    end

    # Checks if a file already exists in the site source
    def file_exists?(file_path)
      pages_and_files.any? { |p| p.url == "/#{file_path}" }
    end

    def pages_and_files
      @pages_and_files ||= @site.pages + @site.static_files
    end
  end
end
