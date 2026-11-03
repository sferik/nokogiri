# frozen_string_literal: true

# Inputs that the benchmarks share. Each is built the same way every
# time, so both versions parse, search and serialize the same bytes.

FILES_DIR = File.expand_path("../test/files", __dir__)

# A fixture from test/files.
def fixture(name)
  File.read(File.join(FILES_DIR, name))
end

# A real blog page, about 70 KB: WordPress markup of its time, with
# inline styles and scripts, comments, entities and a sidebar.
def blog_page
  fixture("tlm.html")
end

# A real Atom feed, about 18 KB, with two namespaces.
def atom_feed
  fixture("atom.xml")
end

# A modern page of this many articles, each with a heading, a byline,
# paragraphs with links, an image and a list of tags: about 1 KB an
# article, plus a header, navigation and footer.
def html_page(articles)
  posts = Array.new(articles) do |i|
    <<~HTML
      <article class="post post-#{i} #{i.even? ? "even" : "odd"}" id="post-#{i}" data-id="#{i}">
        <header>
          <h2 class="title"><a href="/posts/#{i}" rel="bookmark">Post number #{i} &amp; friends</a></h2>
          <p class="byline">By <a class="author" href="/authors/#{i % 7}">Author #{i % 7}</a>
            on <time datetime="2026-10-#{(i % 28) + 1}T12:00:00Z">October #{(i % 28) + 1}, 2026</time></p>
        </header>
        <p class="lead">The quick brown fox jumps over the lazy dog, and <em>then</em> it
          <a href="https://example.com/#{i}?ref=feed&amp;utm_source=blog">reads more</a> about it.</p>
        <img src="/images/#{i}.jpg" alt="Picture #{i}" width="640" height="480" loading="lazy">
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
          <strong>exercitation</strong> ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
        <ul class="tags">
          <li><a href="/tags/ruby" class="tag">ruby</a></li>
          <li><a href="/tags/html" class="tag">html</a></li>
          <li><a href="/tags/#{i % 13}" class="tag">tag #{i % 13}</a></li>
        </ul>
      </article>
    HTML
  end
  <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>A page of #{articles} posts</title>
      <link rel="stylesheet" href="/assets/application.css">
      <script src="/assets/application.js" defer></script>
    </head>
    <body class="index">
      <header id="top"><nav><ul class="menu">
        <li class="active"><a href="/">Home</a></li><li><a href="/about">About</a></li>
        <li><a href="/archive">Archive</a></li><li><a href="/contact">Contact</a></li>
      </ul></nav></header>
      <main id="content">
    #{posts.join}
      </main>
      <footer><p>&copy; 2026 Example. <a href="/privacy">Privacy</a></p></footer>
    </body>
    </html>
  HTML
end

# A snippet of user content, as sanitizers and mailers parse it.
def html_snippet
  <<~HTML
    <p>Hello <b>world</b>, here's <a href="https://example.com/?a=1&amp;b=2" title="a link">a link</a>.</p>
    <ul><li>one</li><li>two &amp; three</li><li><img src="x.png" alt="x"></li></ul>
    <blockquote class="quote">Quoted <i>text</i><br>across lines.</blockquote>
  HTML
end

# A product catalog of this many products in a default namespace, with
# attributes, nested elements, a prefixed namespace and some CDATA: about
# 370 bytes a product.
def catalog_xml(products)
  items = Array.new(products) do |i|
    <<~XML
      <product id="p#{i}" sku="SKU-#{100_000 + i}" available="#{i % 3 != 0}">
        <name>Product #{i} &amp; accessories</name>
        <price currency="USD">#{(i * 37 % 1000) + 0.99}</price>
        <dc:description>A product, number #{i}, for every use you can think of.</dc:description>
        <categories><category>tools</category><category>group-#{i % 11}</category></categories>
        <notes><![CDATA[<b>Ships</b> in #{(i % 5) + 1} days]]></notes>
      </product>
    XML
  end
  <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <catalog xmlns="urn:example:catalog" xmlns:dc="http://purl.org/dc/elements/1.1/" updated="2026-10-24">
    #{items.join}</catalog>
  XML
end

# A SAX handler that does what most do: counts elements, looks at their
# attributes, and collects text.
class CountingHandler < Nokogiri::XML::SAX::Document
  attr_reader :elements, :attributes, :text

  def start_document
    @elements = 0
    @attributes = 0
    @text = 0
  end

  def start_element(name, attrs = [])
    @elements += 1
    @attributes += attrs.size
  end

  def characters(string)
    @text += string.bytesize
  end

  def cdata_block(string)
    @text += string.bytesize
  end
end
