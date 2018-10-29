class ThoughtsController < ApplicationController

	def new
		@thought = current_user.thoughts.create(thought_date: params[:date])
	end

	def update
		@thought = Thought.find(params[:id].to_i)
		@thought.update_attributes(title: params[:title])
		render nothing: true
	end

	def destroy
		@thought = Thought.find(params[:id].to_i)
		@thought_date = @thought.thought_date
		@thought.destroy
	end
end
