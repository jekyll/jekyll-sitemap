require 'fileutils'

module Jekyll
  class JekyllSitemap < Jekyll::Generator
    safe true

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.config["time"]         = Time.new
      @site.config["html_files"]   = html_files.map(&:to_liquid)
      add_updated_data
      unless sitemap_exists?
        write
        @site.keep_files ||= []
        @site.keep_files << "sitemap.xml"
      end
    end

    # Array of all non-jekyll site files with an HTML extension
    def html_files
      @site.static_files.select { |file| File.extname(file.relative_path) == ".html" }
    end

    # Path to sitemap.xml template file
    def source_path
      File.expand_path "sitemap.xml", File.dirname(__FILE__)
    end

    # Destination for sitemap.xml file within the site source directory
    def destination_path
      File.expand_path "sitemap.xml", @site.dest
    end

    # copy sitemap template from source to destination
    def write
      FileUtils.mkdir_p File.dirname(destination_path)
      File.open(destination_path, 'w') { |f| f.write(sitemap_content) }
    end

    def sitemap_content
      site_map = Page.new(@site, File.dirname(__FILE__), "", "sitemap.xml")
      site_map.content = File.read(source_path)
      site_map.render(Hash.new, @site.site_payload)
      site_map.output
    end

    # Checks if a sitemap already exists in the site source
    def sitemap_exists?
      File.exists? File.expand_path "sitemap.xml", @site.source
    end

    def add_updated_data
      @site.posts.each do |post|
        post.data["updated"] = File.mtime(File.expand_path(post.path, @site.source))
      end
      @site.pages.each do |page|
        page.data["updated"] = File.mtime(File.expand_path(page.path, @site.source)) if page.html?
      end
    end
  end
end
