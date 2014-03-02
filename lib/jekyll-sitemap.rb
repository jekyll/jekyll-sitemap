module Jekyll
  class JekyllSitemap < Jekyll::Generator

    safe true

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.config["static_files"] = html_files
      copy unless sitemap_exists?
    end

    # Array of all non-jekyll site files with an HTML extension
    def html_files
      @site.static_files.select { |file| File.extname(file.relative_path) == ".html" }
    end

    # Path to sitemap.xml template file
    def source_path
      File.expand_path 'sitemap.xml', File.dirname(__FILE__)
    end

    # Destination for sitemap.xml file within the site source directory
    def destination_path
      File.expand_path "sitemap.xml", @site.source
    end

    # copy sitemap template from source to destination
    def copy
      copy_file source_path, destination_path
    end

    # Checks if a sitemap already exists in the site source
    def sitemap_exists?
      File.exists? destination_path
    end
  end
end
