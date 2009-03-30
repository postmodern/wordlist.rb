require 'word_list/source'

require 'spidr'

module WordList
  class Website < Source

    def initialize(host,options={})
      @host = host

      super(options)
    end

    def each_word(&block)
      Spidr.host(host) do |spidr|
        spidr.every_page do |page|
          if page.html?
            page.doc.search('h1|h2|h3|h4|h5|p|span').each do |element|
              element.inner_text.split.each(&block)
            end
          end
        end
      end
    end

  end
end
