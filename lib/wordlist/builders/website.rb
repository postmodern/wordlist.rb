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

        options = {
          :proxy        => @proxy,
          :user_agent   => @user_agent,
          :referer      => @referer,
          :hosts        => @hosts,
          :ignore_links => @ignore_links
        }

        xpaths = []
        xpaths << '//meta/@content' if @parse_meta
        xpaths << '//title'         if @parse_title
        xpaths << '//h1'            if @parse_h1
        xpaths << '//h2'            if @parse_h2
        xpaths << '//h3'            if @parse_h3
        xpaths << '//h4'            if @parse_h4
        xpaths << '//h5'            if @parse_h5
        xpaths << '//p'             if @parse_p
        xpaths << '//span'          if @parse_span
        xpaths << '//img/@alt'      if @parse_alt
        xpaths += @xpaths

        Spidr.host(@host,options) do |spidr|
          spidr.every_page do |page|
            if page.html?
              if page.doc
                xpaths.each do |xpath|
                  page.doc.search(xpath).each do |element|
                    parse(element.inner_text)
                  end
                end
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
