class FeedbacksController < ApplicationController
  # GET /feedbacks
  # GET /feedbacks.json
  def index
    if current_user.admin?
      @feedbacks = Feedback.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @feedbacks }
      end
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    if current_user.admin?
      @feedback = Feedback.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @feedback }
      end
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    if current_user.admin?
      @feedback = Feedback.find(params[:id])
    end
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to root_path, notice: 'Feedback was successfully created.' }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    if current_user.admin?
      @feedback = Feedback.find(params[:id])

      respond_to do |format|
        if @feedback.update_attributes(params[:feedback])
          format.html { redirect_to @feedback, notice: 'Feedback was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @feedback.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    if current_user.admin?
      @feedback = Feedback.find(params[:id])
      @feedback.destroy

      respond_to do |format|
        format.html { redirect_to feedbacks_url }
        format.json { head :no_content }
      end
    end
  end
end
