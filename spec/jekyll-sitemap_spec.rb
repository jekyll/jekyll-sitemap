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
  before(:each) do
    site.process
  end

  it "creates a sitemap.xml file" do
    expect(File.exist?(dest_dir("sitemap.xml"))).to be_true
  end
end