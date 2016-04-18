require 'fileutils'

module Jekyll
  class PageWithoutAFile < Page
    def read_yaml(*)
      @data ||= {}
    end
  end

  class JekyllSitemap < Jekyll::Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.config["time"]         = Time.new
      @user_file_extensions        = @site.config["sitemap"]["extensions"]
      @site.config["nonsite_files"] = nonsite_files.map(&:to_liquid)
      unless sitemap_exists?
        write
        @site.keep_files ||= []
        @site.keep_files << "sitemap.xml"
      end
    end

    HTML_EXTENSIONS = %W(
      .html
      .xhtml
      .htm
    ).freeze

    # Array of all non-jekyll site files with an HTML and user defined file extensions
    def nonsite_files
      file_extensions = (HTML_EXTENSIONS + @user_file_extensions).to_set
      @site.static_files.select { |file| file_extensions.include? file.extname }
    end

    # Path to sitemap.xml template file
    def source_path
      File.expand_path "sitemap.xml", File.dirname(__FILE__)
    end

    # Destination for sitemap.xml file within the site source directory
    def destination_path
      if @site.respond_to?(:in_dest_dir)
        @site.in_dest_dir("sitemap.xml")
      else
        Jekyll.sanitized_path(@site.dest, "sitemap.xml")
      end
    end

    # copy sitemap template from source to destination
    def write
      FileUtils.mkdir_p File.dirname(destination_path)
      File.open(destination_path, 'w') { |f| f.write(sitemap_content) }
    end

    def sitemap_content
      site_map = PageWithoutAFile.new(@site, File.dirname(__FILE__), "", "sitemap.xml")
      site_map.content = File.read(source_path)
      site_map.data["layout"] = nil
      site_map.render({}, @site.site_payload)
      site_map.output.gsub(/\s{2,}/, "\n")
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
