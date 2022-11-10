class RecipesController < ApplicationController
    def index
        user = User.find_by(id: session[:user_id])
        if user
            render json: Recipe.all, include: :user, status: :created
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized            
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user 
            recipe = Recipe.new(recipe_params)
            recipe.user_id = session[:user_id]
            if recipe.valid?
                recipe.save
                render json: recipe, include: :user, status: :created
            else
                render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["Not authorized"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end
end
