module Api
  class ListItemsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_todo_list
    before_action :set_list_item, only: %i[show update destroy]

    # GET /api/todolists/:todo_list_id/items
    def index
    end

    # GET /api/todolists/:todo_list_id/items/:id
    def show
    end

    # POST /api/todolists/:todo_list_id/items
    def create
      @list_item = @todo_list.list_items.new(list_item_params)

      if @list_item.save
        render :show, status: :created
      else
        render json: @list_item.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/todolists/:todo_list_id/items/:id
    def update
      if @list_item.update(list_item_params)
        render :show
      else
        render json: @list_item.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/todolists/:todo_list_id/items/:id
    def destroy
      @list_item.destroy
      head :no_content
    end

    private

    def set_todo_list
      @todo_list = TodoList.find(params[:todo_list_id])
    end

    def set_list_item
      @list_item = @todo_list.list_items.find(params[:id])
    end

    def list_item_params
      params.require(:list_item).permit(:description, :done)
    end
  end
end
