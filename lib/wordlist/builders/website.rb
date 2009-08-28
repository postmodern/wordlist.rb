require 'wordlist/builder'

require 'spidr'

module Wordlist
  module Builders
    class Website < Builder

      # Host to spider
      attr_accessor :host

      def initialize(path,options={},&block)
        @host = options[:host]

        super(path,&block)
      end

      def build!(&block)
        Spidr.host(@host) do |spidr|
          spidr.every_page do |page|
            if page.html?
              page.doc.search('h1|h2|h3|h4|h5|p|span').each do |element|
                parse(element.inner_text)
              end
            end
          end
        end

        super(&block)
      end

    end
  end
end
