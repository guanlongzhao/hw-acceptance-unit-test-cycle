require 'rails_helper'

describe MoviesHelper do
    describe "oddness" do
        it "should return correct oddness" do
            expect(oddness(5)).to eq("odd")
            expect(oddness(4)).to eq("even")
        end
    end
end