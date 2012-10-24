module Socialization
  module ActiveRecordStores
    class Favorite < ActiveRecord::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Favorite
      extend Socialization::ActiveRecordStores::Mixins::Base

      belongs_to :favoriter,    :polymorphic => true
      belongs_to :favoritable, :polymorphic => true

      scope :favorited_by, lambda { |favoriter| where(
        :favoriter_type    => favoriter.class.table_name.classify,
        :favoriter_id      => favoriter.id)
      }

      scope :liking,   lambda { |favoritable| where(
        :favoritable_type => favoritable.class.table_name.classify,
        :favoritable_id   => favoritable.id)
      }

      class << self
        def favorite!(favoriter, favoritable)
          unless favorites?(favoriter, favoritable)
            self.create! do |favorite|
              favorite.favoriter = favoriter
              favorite.favoritable = favoritable
            end
            call_after_create_hooks(favoriter, favoritable)
            true
          else
            false
          end
        end

        def unfavorite!(favoriter, favoritable)
          if favorites?(favoriter, favoritable)
            favorite_for(favoriter, favoritable).destroy_all
            call_after_destroy_hooks(favoriter, favoritable)
            true
          else
            false
          end
        end

        def favorites?(favoriter, favoritable)
          !favorite_for(favoriter, favoritable).empty?
        end

        # Returns an ActiveRecord::Relation of all the favoriters of a certain type that are liking  favoritable
        def favoriters_relation(favoritable, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:favoriter_id).
              where(:favoriter_type => klass.table_name.classify).
              where(:favoritable_type => favoritable.class.to_s).
              where(:favoritable_id => favoritable.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the favoriters of a certain type that are liking  favoritable
        def favoriters(favoritable, klass, opts = {})
          rel = favoriters_relation(favoritable, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Returns an ActiveRecord::Relation of all the favoritables of a certain type that are favorited by favoriter
        def favoritables_relation(favoriter, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:favoritable_id).
              where(:favoritable_type => klass.table_name.classify).
              where(:favoriter_type => favoriter.class.to_s).
              where(:favoriter_id => favoriter.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the favoritables of a certain type that are favorited by favoriter
        def favoritables(favoriter, klass, opts = {})
          rel = favoritables_relation(favoriter, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Remove all the favoriters for favoritable
        def remove_favoriters(favoritable)
          self.where(:favoritable_type => favoritable.class.name.classify).
               where(:favoritable_id => favoritable.id).destroy_all
        end

        # Remove all the favoritables for favoriter
        def remove_favoritables(favoriter)
          self.where(:favoriter_type => favoriter.class.name.classify).
               where(:favoriter_id => favoriter.id).destroy_all
        end

      private
        def favorite_for(favoriter, favoritable)
          favorited_by(favoriter).liking( favoritable)
        end
      end # class << self

    end
  end
end
