require File.expand_path(File.dirname(__FILE__))+'/../test_helper'

class FavoriterTest < Test::Unit::TestCase
  context "Favoriter" do
    setup do
      @favoriter = ImAFavoriter.new
      @favoritable = ImAFavoritable.create
    end

    context "#is_favoriter?" do
      should "return true" do
        assert_true @favoriter.is_favoriter?
      end
    end

    context "#favoriter?" do
      should "return true" do
        assert_true @favoriter.favoriter?
      end
    end

    context "#favorite!" do
      should "not accept non-favoritables" do
        assert_raise(Socialization::ArgumentError) { @favoriter.favorite!(:foo) }
      end

      should "call $Favorite.favorite!" do
        $Favorite.expects(:favorite!).with(@favoriter, @favoritable).once
        @favoriter.favorite!(@favoritable)
      end
    end

    context "#unfavorite!" do
      should "not accept non-favoritables" do
        assert_raise(Socialization::ArgumentError) { @favoriter.unfavorite!(:foo) }
      end

      should "call $Favorite.favorite!" do
        $Favorite.expects(:unfavorite!).with(@favoriter, @favoritable).once
        @favoriter.unfavorite!(@favoritable)
      end
    end

    context "#toggle_favorite!" do
      should "not accept non-favoritables" do
        assert_raise(Socialization::ArgumentError) { @favoriter.unfavorite!(:foo) }
      end

      should "unfavorite when favoriteing" do
        @favoriter.expects(:favorites?).with(@favoritable).once.returns(true)
        @favoriter.expects(:unfavorite!).with(@favoritable).once
        @favoriter.toggle_favorite!(@favoritable)
      end

      should "favorite when not favoriteing" do
        @favoriter.expects(:favorites?).with(@favoritable).once.returns(false)
        @favoriter.expects(:favorite!).with(@favoritable).once
        @favoriter.toggle_favorite!(@favoritable)
      end
    end

    context "#favorites?" do
      should "not accept non-favoritables" do
        assert_raise(Socialization::ArgumentError) { @favoriter.unfavorite!(:foo) }
      end

      should "call $Favorite.favorites?" do
        $Favorite.expects(:favorites?).with(@favoriter, @favoritable).once
        @favoriter.favorites?(@favoritable)
      end
    end

    context "#favoritables" do
      should "call $Favorite.favoritables" do
        $Favorite.expects(:favoritables).with(@favoriter, @favoritable.class, { :foo => :bar })
        @favoriter.favoritables(@favoritable.class, { :foo => :bar })
      end
    end

    context "#favoritees" do
      should "call $Favorite.favoritables" do
        $Favorite.expects(:favoritables).with(@favoriter, @favoritable.class, { :foo => :bar })
        @favoriter.favoritees(@favoritable.class, { :foo => :bar })
      end
    end

    context "#favoritables_relation" do
      should "call $Follow.favoritables_relation" do
        $Favorite.expects(:favoritables_relation).with(@favoriter, @favoritable.class, { :foo => :bar })
        @favoriter.favoritables_relation(@favoritable.class, { :foo => :bar })
      end
    end

    context "#favoritees_relation" do
      should "call $Follow.favoritables_relation" do
        $Favorite.expects(:favoritables_relation).with(@favoriter, @favoritable.class, { :foo => :bar })
        @favoriter.favoritees_relation(@favoritable.class, { :foo => :bar })
      end
    end

    should "remove favorite relationships" do
      Socialization.favorite_model.expects(:remove_favoritables).with(@favoriter)
      @favoriter.destroy
    end
  end
end