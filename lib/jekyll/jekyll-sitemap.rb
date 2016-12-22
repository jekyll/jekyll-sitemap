require "fileutils"

module Jekyll
  class JekyllSitemap < Jekyll::Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.pages << sitemap unless file_exists?("sitemap.xml")
    end

    private

    INCLUDED_EXTENSIONS = %W(
      .htm
      .html
      .xhtml
      .pdf
    ).freeze

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
      site_map.content = File.read(source_path)
      site_map.data["layout"] = nil
      site_map.data["static_files"] = static_files.map(&:to_liquid)
      site_map.data["xsl"] = file_exists?("sitemap.xsl")
      site_map
    end

    # Checks if a file already exists in the site source
    def file_exists?(file_path)
      if @site.respond_to?(:in_source_dir)
        File.exist? @site.in_source_dir(file_path)
      else
        File.exist? Jekyll.sanitized_path(@site.source, file_path)
      end
    end
  end
end
