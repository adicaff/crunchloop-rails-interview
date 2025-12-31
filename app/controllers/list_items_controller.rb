class ListItemsController < ApplicationController
  before_action :set_todo_list
  before_action :set_list_item, only: %i[update destroy]

  def create
    @list_item = @todo_list.list_items.new(list_item_params)

    respond_to do |format|
      if @list_item.save
        format.html { redirect_to @todo_list }
        format.turbo_stream
      else
        format.html { render 'todo_lists/show', status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @list_item.update(list_item_params)
        format.html { redirect_to @todo_list }
        format.turbo_stream
      else
        format.html { render 'todo_lists/show', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list_item.destroy
    respond_to do |format|
      format.html { redirect_to @todo_list }
      format.turbo_stream
    end
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
