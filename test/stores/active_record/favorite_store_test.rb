require File.expand_path(File.dirname(__FILE__))+'/../../test_helper'

class ActiveRecordFavoriteStoreTest < Test::Unit::TestCase
  context "ActiveRecordStores::FavoriteStoreTest" do
    setup do
      @klass = Socialization::ActiveRecordStores::Favorite
      @klass.touch nil
      @klass.after_favorite nil
      @klass.after_unfavorite nil
      @favoriter = ImAFavoriter.create
      @favoritable = ImAFavoritable.create
    end

    context "data store" do
      should "inherit Socialization::ActiveRecordStores::Favorite" do
        assert_equal Socialization::ActiveRecordStores::Favorite, Socialization.favorite_model
      end
    end

    context "#favorite!" do
      should "create a Favorite record" do
        @klass.favorite!(@favoriter, @favoritable)
        assert_match_favoriter @klass.last, @favoriter
        assert_match_favoritable @klass.last, @favoritable
      end

      should "touch favoriter when instructed" do
        @klass.touch :favoriter
        @favoriter.expects(:touch).once
        @favoritable.expects(:touch).never
        @klass.favorite!(@favoriter, @favoritable)
      end

      should "touch favoritable when instructed" do
        @klass.touch :favoritable
        @favoriter.expects(:touch).never
        @favoritable.expects(:touch).once
        @klass.favorite!(@favoriter, @favoritable)
      end

      should "touch all when instructed" do
        @klass.touch :all
        @favoriter.expects(:touch).once
        @favoritable.expects(:touch).once
        @klass.favorite!(@favoriter, @favoritable)
      end

      should "call after favorite hook" do
        @klass.after_favorite :after_favorite
        @klass.expects(:after_favorite).once
        @klass.favorite!(@favoriter, @favoritable)
      end

      should "call after unfavorite hook" do
        @klass.after_favorite :after_unfavorite
        @klass.expects(:after_unfavorite).once
        @klass.favorite!(@favoriter, @favoritable)
      end
    end

    context "#favorites?" do
      should "return true when favorite exists" do
        @klass.create! do |f|
          f.favoriter = @favoriter
          f.favoritable = @favoritable
        end
        assert_true @klass.favorites?(@favoriter, @favoritable)
      end

      should "return false when favorite doesn't exist" do
        assert_false @klass.favorites?(@favoriter, @favoritable)
      end
    end

    context "#favoriters" do
      should "return an array of favoriters" do
        favoriter1 = ImAFavoriter.create
        favoriter2 = ImAFavoriter.create
        favoriter1.favorite!(@favoritable)
        favoriter2.favorite!(@favoritable)
        assert_equal [favoriter1, favoriter2], @klass.favoriters(@favoritable, favoriter1.class)
      end

      should "return an array of favoriter ids when plucking" do
        favoriter1 = ImAFavoriter.create
        favoriter2 = ImAFavoriter.create
        favoriter1.favorite!(@favoritable)
        favoriter2.favorite!(@favoritable)
        assert_equal [favoriter1.id, favoriter2.id], @klass.favoriters(@favoritable, favoriter1.class, :pluck => :id)
      end
    end

    context "#favoritables" do
      should "return an array of favoriters" do
        favoritable1 = ImAFavoritable.create
        favoritable2 = ImAFavoritable.create
        @favoriter.favorite!(favoritable1)
        @favoriter.favorite!(favoritable2)
        assert_equal [favoritable1, favoritable2], @klass.favoritables(@favoriter, favoritable1.class)
      end

      should "return an array of favoriter ids when plucking" do
        favoritable1 = ImAFavoritable.create
        favoritable2 = ImAFavoritable.create
        @favoriter.favorite!(favoritable1)
        @favoriter.favorite!(favoritable2)
        assert_equal [favoritable1.id, favoritable2.id], @klass.favoritables(@favoriter, favoritable1.class, :pluck => :id)
      end
    end

    context "#remove_favoriters" do
      should "delete all favoriters relationships for a favoritable" do
        @favoriter.favorite!(@favoritable)
        assert_equal 1, @favoritable.favoriters(@favoriter.class).count
        @klass.remove_favoriters(@favoritable)
        assert_equal 0, @favoritable.favoriters(@favoriter.class).count
      end
    end

    context "#remove_favoritables" do
      should "delete all favoritables relationships for a favoriter" do
        @favoriter.favorite!(@favoritable)
        assert_equal 1, @favoriter.favoritables(@favoritable.class).count
        @klass.remove_favoritables(@favoriter)
        assert_equal 0, @favoriter.favoritables(@favoritable.class).count
      end
    end

  end

  # Helpers
  def assert_match_favoriter(favorite_record, favoriter)
    assert favorite_record.favoriter_type ==  favoriter.class.to_s && favorite_record.favoriter_id == favoriter.id
  end

  def assert_match_favoritable(favorite_record, favoritable)
    assert favorite_record.favoritable_type ==  favoritable.class.to_s && favorite_record.favoritable_id == favoritable.id
  end
end
