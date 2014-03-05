require 'spec_helper'

describe(Jekyll::JekyllSitemap) do
  let(:config) do
    Jekyll.configuration({
      "source"      => source_dir,
      "destination" => dest_dir,
      "url"         => "http://example.org"
    })
  end
  let(:site)   { Jekyll::Site.new(config) }
  let(:contents) { File.read(dest_dir("sitemap.xml")) }
  before(:each) do
    site.process
  end

  it "creates a sitemap.xml file" do
    expect(File.exist?(dest_dir("sitemap.xml"))).to be_true
  end

  it "puts all the pages in the sitemap.xml file" do
    expect(contents).to match /<loc>http:\/\/example\.org\/<\/loc>/
    expect(contents).to match /<loc>http:\/\/example\.org\/some-subfolder\/this-is-a-subpage-baby\.html<\/loc>/
  end

  it "puts all the posts in the sitemap.xml file" do
    expect(contents).to match /<loc>http:\/\/example\.org\/2014\/03\/04\/march-the-fourth\.html<\/loc>/
    expect(contents).to match /<loc>http:\/\/example\.org\/2014\/03\/02\/march-the-second\.html<\/loc>/
    expect(contents).to match /<loc>http:\/\/example\.org\/2013\/12\/12\/dec-the-second\.html<\/loc>/
  end

  it "generates the correct date for each of the posts" do
    expect(contents).to match /<lastmod>2014-03-04T00:00:00-\d+:\d+<\/lastmod>/
    expect(contents).to match /<lastmod>2014-03-02T00:00:00-\d+:\d+<\/lastmod>/
    expect(contents).to match /<lastmod>2013-12-12T00:00:00-\d+:\d+<\/lastmod>/
  end

  it "puts all the static HTML files in the sitemap.xml file" do
    expect(contents).to match /<loc>http:\/\/example\.org\/some-subfolder\/this-is-a-subfile-baby\.html<\/loc>/
  end

  it "does not include assets or any static files that aren't .html" do
    expect(contents).not_to match /<loc>http:\/\/example\.org\/images\/hubot\.png<\/loc>/
  end
end
