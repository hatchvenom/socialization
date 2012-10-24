require File.expand_path(File.dirname(__FILE__))+'/../test_helper'

class FavoritableTest < Test::Unit::TestCase
  context "Favoritable" do
    setup do
      @favoriter = ImAFavoriter.new
      @favoritable = ImAFavoritable.create
    end

    context "#is_favoritable?" do
      should "return true" do
        assert_true @favoritable.is_favoritable?
      end
    end

    context "#favoritable?" do
      should "return true" do
        assert_true @favoritable.favoritable?
      end
    end

    context "#favorited_by?" do
      should "not accept non-favoriters" do
        assert_raise(Socialization::ArgumentError) { @favoritable.favorited_by?(:foo) }
      end

      should "call $Favorite.favorites?" do
        $Favorite.expects(:favorites?).with(@favoriter, @favoritable).once
        @favoritable.favorited_by?(@favoriter)
      end
    end

    context "#favoriters" do
      should "call $Favorite.favoriters" do
        $Favorite.expects(:favoriters).with(@favoritable, @favoriter.class, { :foo => :bar })
        @favoritable.favoriters(@favoriter.class, { :foo => :bar })
      end
    end

    context "#favoriters_relation" do
      should "call $Favorite.favoriters_relation" do
        $Favorite.expects(:favoriters_relation).with(@favoritable, @favoriter.class, { :foo => :bar })
        @favoritable.favoriters_relation(@favoriter.class, { :foo => :bar })
      end
    end

    context "deleting a favoritable" do
      setup do
        @favoriter = ImAFavoriter.create
        @favoriter.favorite!(@favoritable)
      end

      should "remove favorite relationships" do
        Socialization.favorite_model.expects(:remove_favoriters).with(@favoritable)
        @favoritable.destroy
      end
    end

  end
end