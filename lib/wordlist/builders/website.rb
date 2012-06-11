require 'wordlist/builder'

require 'spidr'

module Wordlist
  module Builders
    class Website < Builder

      # Proxy to use
      attr_accessor :proxy

      # User-Agent to use
      attr_accessor :user_agent

      # Referer URL to use
      attr_accessor :referer

      # Host to spider
      attr_accessor :host

      # HTTP Host Header to use in all requests.
      attr_accessor :host_header

      # Additional hosts that can be spidered
      attr_reader :hosts

      # Links to ignore while spidering
      attr_reader :ignore_links

      # Specifies whether the `content` attribute of `meta` tags will be
      # parsed
      attr_accessor :parse_meta

      # Specifies whether `title` tags will be parsed
      attr_accessor :parse_title

      # Specifies whether `h1` tags will be parsed
      attr_accessor :parse_h1

      # Specifies whether `h2` tags will be parsed
      attr_accessor :parse_h2

      # Specifies whether `h3` tags will be parsed
      attr_accessor :parse_h3

      # Specifies whether `h4` tags will be parsed
      attr_accessor :parse_h4

      # Specifies whether `h5` tags will be parsed
      attr_accessor :parse_h5

      # Specifies whether `p` tags will be parsed
      attr_accessor :parse_p

      # Specifies whether `span` tags will be parsed
      attr_accessor :parse_span

      # Specifies whether the `alt` attributes of `img` tags will be parsed
      attr_accessor :parse_alt

      # Specifies whether HTML comment tags will be parsed
      attr_accessor :parse_comments

      # Additional XPath expressions to use to parse spidered pages
      attr_reader :xpaths

      #
      # Creates a new Website builder object.
      #
      # @param [String] path
      #   The path to the word-list to build.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Hash] :proxy
      #   The Hash of proxy information to use.
      #
      # @option options [String] :user_agent
      #   The User-Agent string to send with each request.
      #
      # @option options [String] :referer
      #   The Referer URL to send with each request.
      #
      # @option options [String] :host_header
      #   The HTTP Host header to use in all requests.
      #
      # @option options [Array<String, Regexp, Proc>] :ignore_links
      #   Links to ignore while spidering.
      #
      # @option options [Boolean] :parse_meta (true)
      #   Specifies whether the `content` attribute of `meta` tags will be
      #   parsed.
      #
      # @option options [Boolean] :parse_title (true)
      #   Specifies whether `title` tags will be parsed.
      #
      # @option options [Boolean] :parse_h1 (true)
      #   Specifies whether `h1` tags will be parsed.
      #
      # @option options [Boolean] :parse_h2 (true)
      #   Specifies whether `h2` tags will be parsed.
      #
      # @option options [Boolean] :parse_h3 (true)
      #   Specifies whether `h3` tags will be parsed.
      #
      # @option options [Boolean] :parse_h4 (true)
      #   Specifies whether `h4` tags will be parsed.
      #
      # @option options [Boolean] :parse_h5 (true)
      #   Specifies whether `h5` tags will be parsed.
      #
      # @option options [Boolean] :parse_p (true)
      #   Specifies whether `p` tags will be parsed.
      #
      # @option options [Boolean] :parse_span (true)
      #   Specifies whether `span` tags will be parsed.
      #
      # @option options [Boolean] :parse_alt (true)
      #   Specifies whether the `alt` attributes of `img` tags will be
      #   parsed.
      #
      # @option options [Boolean] :parse_comments (false)
      #   Specifies whether HTML comment tags will be parsed.
      #
      # @option options [Array<String>] :xpaths
      #   Additional list of XPath expressions, to use when parsing
      #   spidered pages.
      #
      def initialize(path,options={},&block)
        @proxy      = options[:proxy]
        @user_agent = options[:user_agent]
        @referer    = options[:referer]

        @host        = options[:host]
        @host_header = options[:host_header]
        @hosts       = Array(options[:hosts])

        @ignore_links = Array(options[:ignore_links])

        @parse_meta     = options.fetch(:parse_meta,true)
        @parse_title    = options.fetch(:parse_title,true)
        @parse_h1       = options.fetch(:parse_h1,true)
        @parse_h2       = options.fetch(:parse_h2,true)
        @parse_h3       = options.fetch(:parse_h3,true)
        @parse_h4       = options.fetch(:parse_h4,true)
        @parse_h5       = options.fetch(:parse_h5,true)
        @parse_p        = options.fetch(:parse_p,true)
        @parse_span     = options.fetch(:parse_span,true)
        @parse_alt      = options.fetch(:parse_alt,true)
        @parse_comments = options.fetch(:parse_comments,false)

        @xpaths = Array(options[:xpaths])

        super(path,options,&block)
      end

      #
      # Builds the word-list file by spidering the `host` and parsing the
      # inner-text from all HTML pages.
      #
      # @yield [builder]
      #   If a block is given, it will be called before all HTML pages on
      #   the `host` have been parsed.
      #
      # @yieldparam [Website] builder
      #   The website word-list builder.
      #
      def build!(&block)
        super(&block)

        search = lambda { |page,xpath|
          if page.doc
            page.doc.search(xpath).each do |element|
              parse(element.inner_text)
            end
          end
        }

        options = {
          :proxy => @proxy,
          :user_agent => @user_agent,
          :referer => @referer,
          :hosts => @hosts,
          :ignore_links => @ignore_links
        }

        Spidr.host(@host,options) do |spidr|
          spidr.every_page do |page|
            if page.html?
              if @parse_meta
                search.call(page,'//meta/@content')
              end

              if @parse_title
                search.call(page,'//title')
              end

              if @parse_h1
                search.call(page,'//h1')
              end

              if @parse_h2
                search.call(page,'//h2')
              end

              if @parse_h3
                search.call(page,'//h3')
              end

              if @parse_h4
                search.call(page,'//h4')
              end

              if @parse_h5
                search.call(page,'//h5')
              end

              if @parse_p
                search.call(page,'//p')
              end

              if @parse_span
                search.call(page,'//span')
              end

              if @parse_alt
                search.call(page,'//img/@alt')
              end

              @xpaths.each do |xpath|
                search.call(page,xpath)
              end

              if (@parse_comments && page.doc)
                page.doc.traverse do |element|
                  parse(element.inner_text) if element.comment?
                end
              end
            end
          end
        end
      end

    end
  end
end
