module Socialization
  module RedisStores
    class Favorite < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Favorite
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :favorite!, :relation!;                          public :favorite!
        alias_method :unfavorite!, :unrelation!;                      public :unfavorite!
        alias_method :favorites?, :relation?;                         public :favorites?
        alias_method :favoriters_relation, :actors_relation;          public :favoriters_relation
        alias_method :favoriters, :actors;                            public :favoriters
        alias_method :favoritables_relation, :victims_relation;      public :favoritables_relation
        alias_method :favoritables, :victims;                        public :favoritables
        alias_method :remove_favoriters, :remove_actor_relations;     public :remove_favoriters
        alias_method :remove_favoritables, :remove_victim_relations; public :remove_favoritables
      end

    end
  end
end
