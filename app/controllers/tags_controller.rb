class TagsController < ApplicationController
	before_action :set_tag, only: :destroy
	def destroy
		render json: {success: true, task_id: params[:task_id]}, status: 200
	end

	private
	def set_tag
		task = Task.find(params[:id])
		@tag = task.tag
		task.update_attributes(tag_id: nil)
	end
end
