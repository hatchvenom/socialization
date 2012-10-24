module ActiveRecord
  class Base
    def is_favoritable?
      false
    end
    alias favoritable? is_favoritable?
  end
end

module Socialization
  module Favoritable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.favorite_model.remove_favoriters(self) }

      # Specifies if self can be favorited.
      #
      # @return [Boolean]
      def is_favoritable?
        true
      end
      alias favoritable? is_favoritable?

      # Specifies if self is favorited by a {Favoriter} object.
      #
      # @return [Boolean]
      def favorited_by?(favoriter)
        raise Socialization::ArgumentError, "#{favoriter} is not favoriter!"  unless favoriter.respond_to?(:is_favoriter?) && favoriter.is_favoriter?
        Socialization.favorite_model.favorites?(favoriter, self)
      end

      # Returns an array of {Favoriter}s liking self.
      #
      # @param [Class] klass the {Favoriter} class to be included. e.g. `User`
      # @return [Array<Favoriter, Numeric>] An array of Favoriter objects or IDs
      def favoriters(klass, opts = {})
        Socialization.favorite_model.favoriters(self, klass, opts)
      end

      # Returns a scope of the {Favoriter}s liking self.
      #
      # @param [Class] klass the {Favoriter} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def favoriters_relation(klass, opts = {})
        Socialization.favorite_model.favoriters_relation(self, klass, opts)
      end

    end
  end
end