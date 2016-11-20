require 'rails_helper'

describe MoviesController do
    describe "#similar_movies" do
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