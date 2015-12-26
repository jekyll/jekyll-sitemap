# encoding: UTF-8

require 'spec_helper'

describe(Jekyll::JekyllSitemap) do
  let(:overrides) do
    {
      "source"      => source_dir,
      "destination" => dest_dir,
      "url"         => "http://example.org",
      "collections" => {
        "my_collection" => { "output" => true },
        "other_things"  => { "output" => false }
      }
    }
  end
  let(:config) do
    Jekyll.configuration(overrides)
  end
  let(:site)     { Jekyll::Site.new(config) }
  let(:contents) { File.read(dest_dir("sitemap.xml")) }
  before(:each) do
    site.process
  end

  it "has no layout" do
    expect(contents).not_to match(/\ATHIS IS MY LAYOUT/)
  end

  it "creates a sitemap.xml file" do
    expect(File.exist?(dest_dir("sitemap.xml"))).to be_truthy
  end

  it "doesn't have multiple new lines or trailing whitespace" do
    expect(contents).to_not match /\s+\n/
    expect(contents).to_not match /\n{2,}/
  end

  it "puts all the pages in the sitemap.xml file" do
    expect(contents).to match /<loc>http:\/\/example\.org\/<\/loc>/
    expect(contents).to match /<loc>http:\/\/example\.org\/some-subfolder\/this-is-a-subpage\.html<\/loc>/
  end

  it "only strips 'index.html' from end of permalink" do
    expect(contents).to match /<loc>http:\/\/example\.org\/some-subfolder\/test_index\.html<\/loc>/
  end

  it "puts all the posts in the sitemap.xml file" do
    expect(contents).to match /<loc>http:\/\/example\.org\/2014\/03\/04\/march-the-fourth\.html<\/loc>/
    expect(contents).to match /<loc>http:\/\/example\.org\/2014\/03\/02\/march-the-second\.html<\/loc>/
    expect(contents).to match /<loc>http:\/\/example\.org\/2013\/12\/12\/dec-the-second\.html<\/loc>/
  end

  describe "collections" do
    it "puts all the `output:true` into sitemap.xml" do
      expect(contents).to match /<loc>http:\/\/example\.org\/my_collection\/test\.html<\/loc>/
    end

    it "doesn't put all the `output:false` into sitemap.xml" do
      expect(contents).to_not match /<loc>http:\/\/example\.org\/other_things\/test2\.html<\/loc>/
    end

    it "remove 'index.html' for directory custom permalinks" do
      expect(contents).to match /<loc>http:\/\/example\.org\/permalink\/<\/loc>/
    end

    it "doesn't remove filename for non-directory custom permalinks" do
      expect(contents).to match /<loc>http:\/\/example\.org\/permalink\/unique_name\.html<\/loc>/
    end

    it "performs URI encoding of site paths" do
      expect(contents).to match /<loc>http:\/\/example\.org\/this%20url%20has%20an%20%C3%BCmlaut<\/loc>/
    end
  end

  it "generates the correct date for each of the posts" do
    expect(contents).to match /<lastmod>2014-03-04T00:00:00(-|\+)\d+:\d+<\/lastmod>/
    expect(contents).to match /<lastmod>2014-03-02T00:00:00(-|\+)\d+:\d+<\/lastmod>/
    expect(contents).to match /<lastmod>2013-12-12T00:00:00(-|\+)\d+:\d+<\/lastmod>/
  end

  it "puts all the static HTML files in the sitemap.xml file" do
    expect(contents).to match /<loc>http:\/\/example\.org\/some-subfolder\/this-is-a-subfile\.html<\/loc>/
  end

  it "does not include assets or any static files that aren't .html" do
    expect(contents).not_to match /<loc>http:\/\/example\.org\/images\/hubot\.png<\/loc>/
    expect(contents).not_to match /<loc>http:\/\/example\.org\/feeds\/atom\.xml<\/loc>/
  end

  it "does include assets or any static files with .xhtml and .htm extensions" do
    expect(contents).to match /\/some-subfolder\/xhtml\.xhtml/
    expect(contents).to match /\/some-subfolder\/htm\.htm/
  end

  it "does not include posts that have set 'sitemap: false'" do
    expect(contents).not_to match /\/exclude-this-post\.html<\/loc>/
  end

  it "does not include pages that have set 'sitemap: false'" do
    expect(contents).not_to match /\/exclude-this-page\.html<\/loc>/
  end

  it "correctly formats timestamps of static files" do
    expect(contents).to match /\/this-is-a-subfile\.html<\/loc>\s+<lastmod>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(-|\+)\d{2}:\d{2}<\/lastmod>/
  end

  it "includes the correct number of items" do
    expect(contents.scan(/(?=<url>)/).count).to eql 15
  end

  context "with a baseurl" do
    let(:config) do
      Jekyll.configuration(Jekyll::Utils.deep_merge_hashes(overrides, {"baseurl" => "/bass"}))
    end

    it "correctly adds the baseurl to the static files" do
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/some-subfolder\/this-is-a-subfile\.html<\/loc>/
    end

    it "correctly adds the baseurl to the collections" do
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/my_collection\/test\.html<\/loc>/
    end

    it "correctly adds the baseurl to the pages" do
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/<\/loc>/
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/some-subfolder\/this-is-a-subpage\.html<\/loc>/
    end

    it "correctly adds the baseurl to the posts" do
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/2014\/03\/04\/march-the-fourth\.html<\/loc>/
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/2014\/03\/02\/march-the-second\.html<\/loc>/
      expect(contents).to match /<loc>http:\/\/example\.org\/bass\/2013\/12\/12\/dec-the-second\.html<\/loc>/
    end
  end

  context "with site url that needs URI encoding" do
    let(:config) do
      Jekyll.configuration(Jekyll::Utils.deep_merge_hashes(overrides, {"url" => "http://has ümlaut.org"}))
    end

    it "performs URI encoding of site url" do
      expect(contents).to match /<loc>http:\/\/has%20%C3%BCmlaut\.org\/<\/loc>/
      expect(contents).to match /<loc>http:\/\/has%20%C3%BCmlaut\.org\/some-subfolder\/this-is-a-subpage\.html<\/loc>/
      expect(contents).to match /<loc>http:\/\/has%20%C3%BCmlaut\.org\/2014\/03\/04\/march-the-fourth\.html<\/loc>/
    end

    it "does not double-escape site url" do
      expect(contents).to_not match /%25/
    end
  end
end
