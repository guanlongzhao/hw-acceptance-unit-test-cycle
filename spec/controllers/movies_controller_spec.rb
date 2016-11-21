require 'rails_helper'

describe MoviesController do
    before :each do
        @movies = [{:title => 'Star Wars', :rating => 'PG',
      	           :director => 'George Lucas', :release_date => '1977-05-25'},
        	        {:title => 'Alien', :rating => 'PG', 
      	           :director => '', :release_date => '1977-05-25'},
      	 ]
    
        @movies.each do |movie|
            Movie.create movie
        end
    end
    
    describe "show" do
        it "should render view show" do
            get :show, :id => 1
            expect(response).to render_template(:show)
        end
    end
    
    describe "index" do
        it "should render view index" do
          expect(get :index).to render_template :index
        end
     
        it "should order the movies by title" do
          get :index, id: @movies, sort: 'title'
          response.status.should be 302 
        end
        
        it "should order the movies by release_date" do
          get :index, id: @movies, sort: 'release_date'
          response.status.should be 302 
        end
        
        it "should filter the movies by ratings" do
          get :index, id: @movies, ratings: { :PG => "1" }
          response.status.should be 302 
        end
    end
    
    describe "new" do
        it "should render view new" do
          expect(get :new).to render_template :new
        end
    end
    
    describe "create" do
      it "should create a new movie" do 
        expect{post :create, :movie => @movies[0]}.to change(Movie, :count).by(1) 
      end
      
      it "should redirect to /movies" do
        post :create, :movie => @movies[0]
        response.should redirect_to(movies_path)
      end
      
      it "should display a flash message" do
        post :create, :movie => @movies[0]
        flash[:notice].should =~ /#{assigns(:movie).title} was successfully created./i
      end
    end
    
    describe "edit" do
        subject { get :edit, id: @movies[1] }
        it "should render view show" do
          expect(get :edit, :id => 1).to render_template :edit
        end
    end
    
    describe "update" do
      it "should be able to change movie's attribute" do
        @movies[1][:director] = "Ridley Scott"
        put :update, :id => 1, :movie => @movies[1]
        Movie.find(1).director.should eq "Ridley Scott"
      end 
      
      it "should redirect to /movies/id afterwards" do 
        @movies[1][:director] = "Ridley Scott"
        put :update, :id => 1, :movie => @movies[1]
        response.should redirect_to movie_path(1)
      end 
      
      it "should display a flash message" do
        @movies[1][:director] = "Ridley Scott"
        put :update, :id => 1, :movie => @movies[1]
        flash[:notice].should =~ /#{@movies[1][:title]} was successfully updated./i
      end
    end
    
    describe "destroy" do
        it "should be able to delete a movie" do 
          expect{delete :destroy, :id => 1}.to change(Movie, :count).by(-1) 
        end 
        
        it "should redirect to index" do 
          delete :destroy, :id => 1
          response.should redirect_to(movies_path)
        end
        
        it "should display a flash message" do
          delete :destroy, :id => 1
          flash[:notice].should =~ /Movie '#{@movies[0][:title]}' deleted./i
        end
    end
    
    describe "similar_movies" do
        # Happy path
        context "When the specified movie has a director" do
            it "should find movies that have the same director" do
                @movie_id = "1"
                @movie = double('fake_movie', :director => 'Random Person')
            
                expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
                
                expect(@movie).to receive(:similar_movies)
            
                get :similar_movies, :id => @movie_id
            
                expect(response).to render_template(:similar_movies)
            end
        end
    
        # Sad path
        context "When the specified movie has no director" do
            it "should redirect to the home page" do
                @movie = double('test_movie').as_null_object # as_null_object prevents runtime errors from calls to the double object; it won't reply, but it won't error out either
                
                expect(Movie).to receive(:find).with("1").and_return(@movie)
                
                get :similar_movies, :id => "1"
                
                expect(response).to redirect_to(movies_path)
            end
        end
    end
end