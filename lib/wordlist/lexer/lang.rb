module Wordlist
  class Lexer
    module Lang
      #
      # The default language.
      #
      # @return [Symbol]
      #
      def self.default
        if (lang = ENV['LANG'])
          lang, encoding = lang.split('.',2)
          lang, country = lang.split('_',2)

          unless lang == 'C'
            lang.to_sym
          else
            :en
          end
        else
          :en
        end
      end
    end
  end
end
