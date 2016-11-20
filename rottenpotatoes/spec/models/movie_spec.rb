require "rails_helper"

describe Movie do
    describe "#similar_movies" do
        it "should find movies that have the same director" do
            movie1 = Movie.create! :director => "Random Guy"
            movie2 = Movie.create! :director => "Random Guy"
            expect(movie1.similar_movies).to include(movie2)
        end
        
        it "should not find movies that have different director" do
            movie1 = Movie.create! :director => "Random Person"
            movie2 = Movie.create! :director => "Random Guy"
            expect(movie1.similar_movies).not_to include(movie2)
        end
    end
    
end