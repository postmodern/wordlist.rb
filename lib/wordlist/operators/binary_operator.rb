# frozen_string_literal: true
require_relative 'operator'

module Wordlist
  module Operators
    #
    # Binary operator base class.
    #
    # @since 1.0.0
    #
    class BinaryOperator < Operator

      # The left operand.
      #
      # @return [Enumerable]
      attr_reader :left

      # The right operand.
      #
      # @return [Enumerable]
      attr_reader :right

      #
      # Initializes the binary operator.
      #
      # @param [Enumerable] left
      #   The left operand.
      #
      # @param [Enumerable] right
      #   The right operand.
      #
      def initialize(left,right)
        @left  = left
        @right = right
      end

    end
  end
end
