# frozen_string_literal: true

require_relative "duel_helper"

# Translating a CSS selector to XPath is pure Ruby: the tokenizer, the
# racc parser and the XPath visitor. Searchable#css caches each
# translation, by selector and visitor, so these benchmarks pass
# cache: false to time the translation itself, and one times the lookup
# that every css call makes when the selector is cached.

duel "css: translate a type and a class" do
  Nokogiri::CSS.xpath_for("div.post", cache: false)
end

duel "css: translate descendants, a child and an attribute" do
  Nokogiri::CSS.xpath_for("main > article.post h2 a[href^='/posts']", cache: false)
end

duel "css: translate pseudo-classes" do
  Nokogiri::CSS.xpath_for("ul.tags li:nth-child(2n+1) a:not(.active), p:first-of-type", cache: false)
end

duel "css: translate a list of five selectors" do
  Nokogiri::CSS.xpath_for("h1, h2.title, h3 + p, td:contains('total'), input[type=submit]", cache: false)
end

duel "css: translate for an HTML5 document" do
  once do
    @visitor = Nokogiri::CSS::XPathVisitor.new(
      builtins: Nokogiri::CSS::XPathVisitor::BuiltinsConfig::OPTIMAL,
      doctype: Nokogiri::CSS::XPathVisitor::DoctypeConfig::HTML5,
    )
  end
  Nokogiri::CSS.xpath_for("article.post header > h2 a", visitor: @visitor, cache: false)
end

duel "css: look up a cached translation" do
  once { Nokogiri::CSS.xpath_for("article.post h2 a") }
  Nokogiri::CSS.xpath_for("article.post h2 a")
end
