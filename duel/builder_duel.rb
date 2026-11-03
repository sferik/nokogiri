# frozen_string_literal: true

require_relative "duel_helper"

# Building documents: Nokogiri::XML::Builder's method_missing DSL, and
# making and adding nodes directly, then serializing the result.

duel "builder: build a 50-item XML feed" do
  Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
    xml.feed(xmlns: "http://www.w3.org/2005/Atom") do
      xml.title("A feed")
      50.times do |i|
        xml.entry do
          xml.id_("tag:example.com,2026:#{i}")
          xml.title("Entry #{i} & more")
          xml.link(rel: "alternate", href: "https://example.com/#{i}")
          xml.content("Some content for entry #{i}", type: "text")
        end
      end
    end
  end.to_xml
end

duel "builder: add 50 elements with attributes to a document" do
  doc = Nokogiri::XML::Document.new
  root = doc.create_element("items")
  doc.root = root
  50.times do |i|
    item = doc.create_element("item", "Item #{i}", id: "i#{i}")
    item["class"] = "item"
    root.add_child(item)
  end
  doc
end
