# frozen_string_literal: true

require_relative "duel_helper"

# Reading a parsed tree: walking it, and asking each node for its
# attributes, text and neighbours. Each node is a Ruby object over a
# libxml2 node, made the first time it's seen and kept after, so `once`
# visits every node first and the benchmarks time the reading.

duel "traverse: walk every node of a 70 KB blog page" do
  once do
    @doc = Nokogiri::HTML4(blog_page)
    @doc.traverse { |_node| nil }
  end
  @doc.traverse { |_node| nil }
end

duel "traverse: read every link's href and text" do
  once { @links = Nokogiri::HTML4(html_page(50)).css("a") }
  @links.each do |link|
    link["href"]
    link.text
  end
end

duel "traverse: read each element's attributes as a hash" do
  once { @elements = Nokogiri::HTML4(html_page(50)).css("article *") }
  @elements.each(&:attributes)
end

duel "traverse: read classes and check for a class" do
  once { @elements = Nokogiri::HTML4(html_page(50)).css("[class]") }
  @elements.each do |element|
    element.classes
    element.key?("data-id")
  end
end

duel "traverse: children, parent and next element of each" do
  once { @elements = Nokogiri::HTML4(html_page(50)).css("article") }
  @elements.each do |element|
    element.element_children
    element.parent
    element.next_element
  end
end

duel "traverse: ancestors of every link" do
  once { @links = Nokogiri::HTML4(html_page(50)).css("a") }
  @links.each(&:ancestors)
end
