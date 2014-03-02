# Monkey Patch Jekyll 2.0.0 static file treatment back to Jekyll 1.4.x
# See https://github.com/jekyll/jekyll/pull/2075/files

module Jekyll
  class StaticFile

    # Returns the source file path relative to the site source
    def relative_path
      @relative_path ||= path.sub(/\A#{@site.source}/, '')
    end

    def to_liquid
      {
        "path"          => relative_path,
        "modified_time" => mtime.to_s,
        "extname"       => File.extname(relative_path)
      }
    end

  end
end
