# frozen_string_literal: true

require_relative "duel_helper"

# Parsing is what every use of Nokogiri starts with: libxml2's HTML4 and
# XML parsers, and libgumbo's HTML5 parser, through the extension, which
# also wraps the tree and reads the document's encoding. Each benchmark
# parses a string read in `once`, so nothing touches the disk.

duel "html4: parse a small page" do
  once { @html = html_page(5) }
  Nokogiri::HTML4(@html)
end

duel "html4: parse a 70 KB blog page" do
  once { @html = blog_page }
  Nokogiri::HTML4(@html)
end

duel "html4: parse a 320 KB page" do
  once { @html = html_page(300) }
  Nokogiri::HTML4(@html)
end

duel "html4: parse a fragment" do
  once { @html = html_snippet }
  Nokogiri::HTML4.fragment(@html)
end

duel "html5: parse a small page" do
  once { @html = html_page(5) }
  Nokogiri::HTML5(@html)
end

duel "html5: parse a 70 KB blog page" do
  once { @html = blog_page }
  Nokogiri::HTML5(@html)
end

duel "html5: parse a 320 KB page" do
  once { @html = html_page(300) }
  Nokogiri::HTML5(@html)
end

duel "html5: parse a fragment" do
  once { @html = html_snippet }
  Nokogiri::HTML5.fragment(@html)
end

duel "xml: parse an 18 KB Atom feed" do
  once { @xml = atom_feed }
  Nokogiri::XML(@xml)
end

duel "xml: parse a 300 KB catalog" do
  once { @xml = catalog_xml(800) }
  Nokogiri::XML(@xml)
end
