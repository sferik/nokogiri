# frozen_string_literal: true

require_relative "duel_helper"

# Serializing a parsed tree back to markup: libxml2's serializers for
# HTML4 and XML, through the extension's IO callbacks, and the
# extension's own HTML5 serializer.

duel "serialize: to_html a 70 KB blog page" do
  once { @doc = Nokogiri::HTML4(blog_page) }
  @doc.to_html
end

duel "serialize: to_html an HTML5 document" do
  once { @doc = Nokogiri::HTML5(html_page(50)) }
  @doc.to_html
end

duel "serialize: to_xml an 18 KB Atom feed" do
  once { @doc = Nokogiri::XML(atom_feed) }
  @doc.to_xml
end

duel "serialize: inner_html of an element" do
  once { @article = Nokogiri::HTML4(html_page(5)).at_css("article") }
  @article.inner_html
end
