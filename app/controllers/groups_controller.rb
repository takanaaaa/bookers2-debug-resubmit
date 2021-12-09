class GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.users << current_user
    @group.owner_id = current_user.id
    p @group
    if @group.save
      redirect_to group_path(@group), notice: "グループの作成に成功しました。"
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @book = Book.new
  end

  def index
    @groups = Group.all
    @book = Book.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "更新に成功しました。"
    else
      render :edit
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end
