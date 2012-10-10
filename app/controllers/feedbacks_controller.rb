class FeedbacksController < ApplicationController
  load_and_authorize_resource
  before_filter :load_review

  def load_review
    @review = Review.find(params[:review_id])
  end

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = []
    Feedback.all.each do |feedback|
      if can? :read, feedback
        @feedbacks << feedback
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new
    @user_name = current_user.name

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
    @user_name = current_user.name
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.review = @review
    @feedback.user = current_user

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to [@review, @feedback], notice: 'Feedback was successfully created.' }
        format.json { render json: [@review, @feedback], status: :created, location: [@review, @feedback] }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { redirect_to [@review, @feedback], notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to review_feedbacks_url(@review) }
      format.json { head :no_content }
    end
  end
end