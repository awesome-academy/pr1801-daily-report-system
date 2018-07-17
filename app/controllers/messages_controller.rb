class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :find_conversation

  def index
    @messages = @conversation.messages
    @messages.where.not(user_id: current_user.id, read: true).update_all(read: true)
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user
    if @message.save
      flash[:success] = t("send_msg")
      redirect_to conversation_messages_path(@conversation)
    else
      flash[:error] = t("error")
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private
  def find_conversation
    @conversation = Conversation.find_by id: params[:conversation_id]
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
