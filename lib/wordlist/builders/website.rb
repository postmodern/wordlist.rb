require 'wordlist/builder'

require 'spidr'

module Wordlist
  module Builders
    class Website < Builder

      # Host to spider
      attr_accessor :host

      #
      # Creates a new Website builder object with the specified _path_
      # and _host_. If a _block_ is given, it will be passed the new created
      # Website builder object.
      #
      def initialize(path,host,&block)
        @host = host

        super(path,&block)
      end

      #
      # Builds the word-list file by spidering the +host+ and parsing the
      # inner-text from all HTML pages. If a _block_ is given, it will be
      # called before all HTML pages on the +host+ have been parsed.
      #
      def build!(&block)
        super(&block)

        Spidr.host(@host) do |spidr|
          spidr.every_page do |page|
            if page.html?
              page.doc.search('//meta/@content|//title|//h1|//h2|//h3|//h4|//h5|//p|//span|//img/@alt').each do |element|
                parse(element.inner_text)
              end

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
