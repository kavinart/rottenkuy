class Movie < ActiveRecord::Base
	def self.ratings
		tmp = []
		Movie.all.each {|movie| tmp << movie.rating}
		return tmp.uniq
	end
end
