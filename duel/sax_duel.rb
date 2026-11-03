# frozen_string_literal: true

require_relative "duel_helper"

# SAX parsing calls back into Ruby for every element and every run of
# text, so the extension's callbacks, and the Ruby that turns each
# element's attributes into the arguments of start_element, run once an
# element.

duel "sax: parse an 18 KB Atom feed" do
  once do
    @xml = atom_feed
    @parser = Nokogiri::XML::SAX::Parser.new(CountingHandler.new)
  end
  @parser.parse(@xml)
end

duel "sax: parse a 300 KB catalog" do
  once do
    @xml = catalog_xml(800)
    @parser = Nokogiri::XML::SAX::Parser.new(CountingHandler.new)
  end
  @parser.parse(@xml)
end

duel "sax: parse a 70 KB blog page as HTML" do
  once do
    @html = blog_page
    @parser = Nokogiri::HTML4::SAX::Parser.new(CountingHandler.new)
  end
  @parser.parse(@html)
end

duel "sax: push the Atom feed in 1 KB chunks" do
  once do
    xml = atom_feed
    @chunks = (0...xml.bytesize).step(1024).map { |offset| xml.byteslice(offset, 1024) }
  end
  parser = Nokogiri::XML::SAX::PushParser.new(CountingHandler.new)
  @chunks.each { |chunk| parser << chunk }
  parser.finish
end
