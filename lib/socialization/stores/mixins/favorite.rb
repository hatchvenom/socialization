module Socialization
  module Stores
    module Mixins
      module Favorite

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :favoriter, :favoritable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_favorite(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_unfavorite(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(favoriter, favoritable)
          self.send(@after_create_hook, favoriter, favoritable) if @after_create_hook
          touch_dependents(favoriter, favoritable)
        end

        def call_after_destroy_hooks(favoriter, favoritable)
          self.send(@after_destroy_hook, favoriter, favoritable) if @after_destroy_hook
          touch_dependents(favoriter, favoritable)
        end

      end
    end
  end
end