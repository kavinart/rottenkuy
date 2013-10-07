class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @check_boxes = @all_ratings

    if params[:ratings] != nil
      @check_boxes = []
      if params[:ratings].is_a?(Hash)
        params[:ratings].each_key do |rating|
          @check_boxes << rating 
        end
      elsif params[:ratings].kind_of?(Array)
        params[:ratings].each do |rating|
          @check_boxes << rating 
        end
      end
    end

    @sort_by = params[:sort_by] || session[:sort_by]
    if params[:sort_by] != session[:sort_by]
      session[:sort_by] = @sort_by
    end
    @ratings = params[:ratings] || session[:ratings]
    if params[:ratings] != session[:ratings]
      session[:ratings] = @ratings
    end

    if (params[:sort_by] == nil && session[:sort_by] != nil) || (params[:ratings] == nil && session[:ratings] != nil)
      flash.keep
      redirect_to movies_path({:sort_by => session[:sort_by], :ratings => session[:ratings]})
    elsif params[:sort_by] == nil && session[:sort_by] != nil
      session[:sort_by] = params[:sort_by]
    else
      session[:ratings] = params[:ratings]
    end

    if params[:ratings] == nil
      params[:ratings] = session[:ratings]
    end
    
    if @sort_by == 'Movie Title'
      @movies = Movie.order('title')
      @movies = @movies.find_all_by_rating(@check_boxes)
    elsif @sort_by == 'Release Date'
      @movies = Movie.order('release_date')
      @movies = @movies.find_all_by_rating(@check_boxes)
    else
      @movies = Movie.order(session[:sort_by])
      @movies = @movies.find_all_by_rating(@check_boxes)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
