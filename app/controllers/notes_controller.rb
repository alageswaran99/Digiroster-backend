class NotesController < ApplicationController
  before_action :validate_params, only: [:create, :update]
  before_action :set_note, only: [:show, :update, :destroy]
  decorate_views

  def index
    @items = scoper.all
  end

  def show
  end

  def create
    @item = current_agent.notes.new(note_params)
    if @item.save
      render :show, status: :created
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(note_params)
      render :show, status: :ok
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    access_denied
  end

  private

    def scoper
      current_agent.carer? ? current_agent.notes.includes([:appointment]) : current_account.notes.includes([:appointment])
    end

    def set_note
      @item = scoper.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      raise CustomErrors::NotFound, 'Invalid Resource ID'
    end

    def note_params
      params.require(:note).permit(:data, :client_id, :appointment_id)
    end

    def validate_params
      @note_delegator = NoteDelegator.new(params, {context: @_action_name.to_sym})
      unless @note_delegator.valid?
        render :show, status: :unprocessable_entity
      end
    end
end
