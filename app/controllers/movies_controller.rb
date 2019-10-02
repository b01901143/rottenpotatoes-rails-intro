class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort_by] = params[:sort_by] if params[:sort_by]
    
    @all_ratings = Movie.ratings.map { |rating| {name: rating, value: session[:ratings] ? session[:ratings].include?(rating) : true} }
    @movies = session[:ratings]&.any? ? Movie.with_ratings(session[:ratings].keys) : Movie.all

    if session[:sort_by]
      @movies = @movies.order(session[:sort_by])
      @title_header = 'hilite' if session[:sort_by] == 'title'
      @release_date_header = 'hilite' if session[:sort_by] == 'release_date'
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
