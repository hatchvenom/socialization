require File.expand_path(File.dirname(__FILE__))+'/../../test_helper'

class RedisFavoriteStoreTest < Test::Unit::TestCase
  context "RedisStores::Favorite" do
    setup do
      use_redis_store
      @klass = Socialization::RedisStores::Favorite
      @base = Socialization::RedisStores::Base
    end

    context "method aliases" do
      should "be set properly and made public" do
        assert_method_public @klass, :favorite!
        assert_method_public @klass, :unfavorite!
        assert_method_public @klass, :favorites?
        assert_method_public @klass, :favoriters_relation
        assert_method_public @klass, :favoriters
        assert_method_public @klass, :favoritables_relation
        assert_method_public @klass, :favoritables
        assert_method_public @klass, :remove_favoriters
        assert_method_public @klass, :remove_favoritables
      end
    end
  end
end