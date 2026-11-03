# frozen_string_literal: true

require_relative "duel_helper"

# Searching a parsed document: css and at_css translate the selector (a
# cached lookup after the first call, which `once` makes) and run the
# XPath through libxml2, and xpath runs it directly. Each result is
# wrapped as a NodeSet of Ruby nodes.

duel "search: css on a 70 KB blog page" do
  once do
    @doc = Nokogiri::HTML4(blog_page)
    @doc.css("div.post h2 a")
  end
  @doc.css("div.post h2 a")
end

duel "search: at_css on a 70 KB blog page" do
  once do
    @doc = Nokogiri::HTML4(blog_page)
    @doc.at_css("div#sidebar li a")
  end
  @doc.at_css("div#sidebar li a")
end

duel "search: css for every link on a 320 KB page" do
  once do
    @doc = Nokogiri::HTML4(html_page(300))
    @doc.css("a[href]")
  end
  @doc.css("a[href]")
end

duel "search: css on an HTML5 document" do
  once do
    @doc = Nokogiri::HTML5(html_page(50))
    @doc.css("article.post > header h2.title a")
  end
  @doc.css("article.post > header h2.title a")
end

duel "search: css within each of 50 articles" do
  once do
    @articles = Nokogiri::HTML4(html_page(50)).css("article")
    @articles.each { |article| article.at_css("h2 a") }
  end
  @articles.each { |article| article.at_css("h2 a") }
end

duel "search: xpath on a 70 KB blog page" do
  once { @doc = Nokogiri::HTML4(blog_page) }
  @doc.xpath("//div[@class='post']//a[@href]")
end

duel "search: xpath with a namespace in an Atom feed" do
  once { @doc = Nokogiri::XML(atom_feed) }
  @doc.xpath("//xmlns:entry/xmlns:link/@href")
end

duel "search: css in an Atom feed" do
  once do
    @doc = Nokogiri::XML(atom_feed)
    @doc.css("entry > title")
  end
  @doc.css("entry > title")
end
