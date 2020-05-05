module Refinery
  module Addons
    class CommentsController < ::ApplicationController

      def create
        @comment_creator = CommentCreator.new_in_model(current_refinery_user.comments.build, params[:comment], current_refinery_user)
        @comment_creator.save
        redirect_to params[:return_to]
      end

      protected

      def comment_params
        params.require(:comment).permit(:commentable_id, :commentable_type, :body)
      end

    end
  end
end
