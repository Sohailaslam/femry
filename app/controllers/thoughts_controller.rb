class ThoughtsController < ApplicationController

	def update
		@thought = Thought.find(params[:id].to_i)
		@thought.update_attributes(title: params[:title])
		render nothing: true
	end

	def destroy
		@thought = Thought.find(params[:id].to_i)
		@thought.destroy
		render plain: "OK"
	end
end
