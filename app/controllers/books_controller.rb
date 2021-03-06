class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @newbook = Book.new
    @book = Book.find(params[:id])
    unless ViewCount.find_by(book_id: @book.id, user_id: current_user.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def index
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to - 1.week).at_beginning_of_day
    if params[:sort] == "newArrival"
      @books = Book.order(created_at: :desc)
    elsif params[:sort] == "evaluation"
      @books = Book.order(evaluation: :desc)
    else
      @books = Book.includes(:favorited_users).where(created_at: from...to).sort{|a,b| b.favorited_users.size <=> a.favorited_users.size}
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :evaluation)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
    redirect_to books_path
    end
  end
end
