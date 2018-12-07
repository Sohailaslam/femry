class TagsController < ApplicationController
	before_action :set_tag, only: :destroy
	def destroy
		@tag.destroy if @tag.present?
		render json: {success: true, id: @tag.id, task_id: params[:task_id]}, status: 200
	end

	private
	def set_tag
		@tag = Tag.find(params[:id])
	end
end
