class ItemResolveController < ApplicationController
  before_action :find_item, only: %i[create destroy]
  before_action :find_checklist, only: %i[create destroy]

  def create
    @item.complete!
  end

  def destroy
    @item.undo!
  end

  private

  def find_checklist
    @checklist = Checklist.find(params[:checklist_id])
  end

  def find_item
    @item = Item.find(params[:item_id])
  end
end
