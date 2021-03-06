class RecipesController < ApplicationController
  after_action :save_search_history, only: :search, if: -> { signed_in? }

  def generate
    id = Recipe.select(:id).find_by(generate_params)
    if id.nil?
      redirect_back(fallback_location: root_path)
    else
      redirect_to recipe_path(id: id)
    end
  end

  def suggest
    @recipes = Recipe.name_liked(params[:name]).select(:id, :name)
    render layout: false
  end

  def search
    @recipes = Recipe.name_liked(params[:name]).page(params[:page])
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def generate_params
    params.require(:recipe).permit(:name)
  end

  def save_search_history
    current_user.search_histories.create(keyword: params[:name])
  end
end
