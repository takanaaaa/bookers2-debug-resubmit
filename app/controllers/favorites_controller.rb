class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.create(book_id: @book.id)
    to = Time.current.at_end_of_day
    from = (to - 1.week).at_beginning_of_day
    @books = Book.includes(:favorited_users).where(created_at: from...to).sort{|a,b| b.favorited_users.size <=> a.favorited_users.size}
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    to = Time.current.at_end_of_day
    from = (to - 1.week).at_beginning_of_day
    @books = Book.includes(:favorited_users).where(created_at: from...to).sort{|a,b| b.favorited_users.size <=> a.favorited_users.size}
  end
end
