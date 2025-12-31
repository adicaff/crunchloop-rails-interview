module Api
  class TodoListsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!
    before_action :set_todo_list, only: %i[show update destroy]

    # GET /api/todolists
    def index
      @todo_lists = current_user.todo_lists
    end

    # GET /api/todolists/:id
    def show; end

    # POST /api/todolists
    def create
      @todo_list = current_user.todo_lists.new(todo_list_params)

      if @todo_list.save
        render :show, status: :created
      else
        render json: @todo_list.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/todolists/:id
    def update
      if @todo_list.update(todo_list_params)
        render :show
      else
        render json: @todo_list.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/todolists/:id
    def destroy
      @todo_list.destroy
      head :no_content
    end

    private

    def set_todo_list
      @todo_list = current_user.todo_lists.find(params[:id])
    end

    def todo_list_params
      params.require(:todo_list).permit(:name)
    end
  end
end
