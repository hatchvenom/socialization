module ActiveRecord
  class Base
    def is_favoriter?
      false
    end
    alias favoriter? is_favoriter?
  end
end

module Socialization
  module Favoriter
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.favorite_model.remove_favoritables(self) }

      # Specifies if self can favorite {Favoritable} objects.
      #
      # @return [Boolean]
      def is_favoriter?
        true
      end
      alias favoriter? is_favoriter?

      # Create a new {Favorite favorite} relationship.
      #
      # @param [Favoritable] favoritable the object to be favorited.
      # @return [Boolean]
      def favorite!(favoritable)
        raise Socialization::ArgumentError, "#{favoritable} is not favoritable!"  unless favoritable.respond_to?(:is_favoritable?) && favoritable.is_favoritable?
        Socialization.favorite_model.favorite!(self, favoritable)
      end

      # Delete a {Favorite favorite} relationship.
      #
      # @param [Favoritable] favoritable the object to unfavorite.
      # @return [Boolean]
      def unfavorite!(favoritable)
        raise Socialization::ArgumentError, "#{favoritable} is not favoritable!" unless favoritable.respond_to?(:is_favoritable?) && favoritable.is_favoritable?
        Socialization.favorite_model.unfavorite!(self, favoritable)
      end

      # Toggles a {Favorite favorite} relationship.
      #
      # @param [Favoritable] favoritable the object to favorite/unfavorite.
      # @return [Boolean]
      def toggle_favorite!(favoritable)
        raise Socialization::ArgumentError, "#{favoritable} is not favoritable!" unless favoritable.respond_to?(:is_favoritable?) && favoritable.is_favoritable?
        if favorites?(favoritable)
          unfavorite!(favoritable)
          false
        else
          favorite!(favoritable)
          true
        end
      end

      # Specifies if self favorites a {Favoritable} object.
      #
      # @param [Favoritable] favoritable the {Favoritable} object to test against.
      # @return [Boolean]
      def favorites?(favoritable)
        raise Socialization::ArgumentError, "#{favoritable} is not favoritable!" unless favoritable.respond_to?(:is_favoritable?) && favoritable.is_favoritable?
        Socialization.favorite_model.favorites?(self, favoritable)
      end

      # Returns all the favoritables of a certain type that are favorited by self
      #
      # @params [Favoritable] klass the type of {Favoritable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<Favoritable, Numeric>] An array of Favoritable objects or IDs
      def favoritables(klass, opts = {})
        Socialization.favorite_model.favoritables(self, klass, opts)
      end
      alias :favoritees :favoritables

      # Returns a relation for all the favoritables of a certain type that are favorited by self
      #
      # @params [Favoritable] klass the type of {Favoritable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def favoritables_relation(klass, opts = {})
        Socialization.favorite_model.favoritables_relation(self, klass, opts)
      end
      alias :favoritees_relation :favoritables_relation
    end
  end
end