require 'wordlist/builder'

require 'spidr'

module Wordlist
  module Builders
    class Website < Builder

      # Host to spider
      attr_accessor :host

      # Specifies whether the +content+ attribute of +meta+ tags will be
      # parsed
      attr_accessor :parse_meta

      # Specifies whether +title+ tags will be parsed
      attr_accessor :parse_title

      # Specifies whether +h1+ tags will be parsed
      attr_accessor :parse_h1

      # Specifies whether +h2+ tags will be parsed
      attr_accessor :parse_h2

      # Specifies whether +h3+ tags will be parsed
      attr_accessor :parse_h3

      # Specifies whether +h4+ tags will be parsed
      attr_accessor :parse_h4

      # Specifies whether +h5+ tags will be parsed
      attr_accessor :parse_h5

      # Specifies whether +p+ tags will be parsed
      attr_accessor :parse_p

      # Specifies whether +span+ tags will be parsed
      attr_accessor :parse_span

      # Specifies whether the +alt+ attributes of +img+ tags will be parsed
      attr_accessor :parse_alt

      # Specifies whether HTML comment tags will be parsed
      attr_accessor :parse_comments

      # Additional XPath expressions to use to parse spidered pages
      attr_reader :xpaths

      #
      # Creates a new Website builder object with the specified _path_
      # and the given _options_. If a _block_ is given, it will be passed
      # the new created Website builder object.
      #
      # _options_ may include the following keys:
      # <tt>:host</tt>:: The host to spider and build the wordlist from.
      # <tt>:parse_meta</tt>:: Specifies whether the +content+ attribute of
      #                        +meta+ tags will be parsed. Defaults to
      #                        +true+ if not given.
      # <tt>:parse_title</tt>:: Specifies whether +title+ tags will be
      #                         parsed. Defaults to +true+ if not given.
      # <tt>:parse_h1</tt>:: Specifies whether +h1+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_h2</tt>:: Specifies whether +h2+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_h3</tt>:: Specifies whether +h3+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_h4</tt>:: Specifies whether +h4+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_h5</tt>:: Specifies whether +h5+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_p</tt>:: Specifies whether +p+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_span</tt>:: Specifies whether +span+ tags will be parsed.
      #                      Defaults to +true+ if not given.
      # <tt>:parse_alt</tt>:: Specifies whether the +alt+ attributes of
      #                       +img+ tags will be parsed. Defaults to +true+
      #                       if not given.
      # <tt>:parse_comments</tt>:: Specifies whether HTML comment tags will
      #                            be parsed. Defaults to +false+ if not
      #                            given.
      # <tt>:xpaths</tt>:: Additional list of XPath expressions, to use
      #                    when parsing spidered pages.
      #
      def initialize(path,options={},&block)
        @host = options[:host]

        @parse_meta = true
        @parse_title = true
        @parse_h1 = true
        @parse_h2 = true
        @parse_h3 = true
        @parse_h4 = true
        @parse_h5 = true
        @parse_p = true
        @parse_span = true
        @parse_alt = true
        @parse_comments = false

        if options.has_key?(:parse_meta)
          @parse_meta = options[:parse_meta]
        end

        if options.has_key?(:parse_title)
          @parse_title = options[:parse_title]
        end

        if options.has_key?(:parse_h1)
          @parse_h1 = options[:parse_h1]
        end

        if options.has_key?(:parse_h2)
          @parse_h2 = options[:parse_h2]
        end

        if options.has_key?(:parse_h3)
          @parse_h3 = options[:parse_h3]
        end

        if options.has_key?(:parse_h4)
          @parse_h4 = options[:parse_h4]
        end

        if options.has_key?(:parse_h5)
          @parse_h5 = options[:parse_h5]
        end

        if options.has_key?(:parse_p)
          @parse_p = options[:parse_p]
        end

        if options.has_key?(:parse_span)
          @parse_span = options[:parse_span]
        end

        if options.has_key?(:parse_comments)
          @parse_comments = options[:parse_comments]
        end

        @xpaths = []

        if options[:xpaths]
          @xpaths += options[:xpaths]
        end

        super(path,options,&block)
      end

      #
      # Builds the word-list file by spidering the +host+ and parsing the
      # inner-text from all HTML pages. If a _block_ is given, it will be
      # called before all HTML pages on the +host+ have been parsed.
      #
      def build!(&block)
        super(&block)

        search = lambda { |page,xpath|
          page.doc.search(xpath).each { |element|
            parse(element.inner_text)
          }
        }

        Spidr.host(@host) do |spidr|
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

              if @parse_comments
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
