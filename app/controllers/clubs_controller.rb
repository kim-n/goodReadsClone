class ClubsController < ApplicationController

  before_filter :require_current_user!, except: [:index, :show]

  def index
    @clubs = Club.all
    render :index
  end

  def create
    params[:club][:books_ids].delete("")
    if params[:club][:books_ids].empty?
      flash[:errors] = ["Clubs must have atleast 1 book"]
      redirect_to new_club_url
    else
      club = current_user.created_clubs.new(params[:club])
      if club.save
        redirect_to club_url(club)
      else
        flash[:errors] = club.errors.full_messages
        render :new
      end
    end
  end

  def show
    @club = Club.find_by_id(params[:id])

    if @club
      @posts = @club.posts.select("posts.*, users.name AS username, books.title AS bookname, books.isbn AS bookisbn").joins("INNER JOIN users ON posts.user_id=users.id").joins("INNER JOIN books ON posts.book_id=books.id")
      @books = Book.all
      @clubbooks = @club.books
      render :show
    else
      redirect_to clubs_url
    end
  end

  def new
    @books = Book.all
    render :new
  end

  def destroy
    club = Club.find(params[:id])

    if is_administrator?(current_user) || current_user.id == club.creator.id
      flash[:errors] = ["#{club.title} destroyed!"]
      club.destroy
      redirect_to clubs_admin_url
    else
      flash[:errors] = ["Must be club owner to delete!"]
      redirect_to club_url(club)
    end
  end
end
