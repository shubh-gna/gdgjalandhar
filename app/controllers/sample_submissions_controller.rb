class SampleSubmissionsController < ApplicationController
  before_action :set_sample_submission, only: %i[ show edit update destroy ]

  # GET /sample_submissions or /sample_submissions.json
  def index
    @sample_submissions = SampleSubmission.all
  end

  # GET /sample_submissions/1 or /sample_submissions/1.json
  def show
  end

  # GET /sample_submissions/new
  def new
    @sample_submission = SampleSubmission.new
  end

  # GET /sample_submissions/1/edit
  def edit
  end

  # POST /sample_submissions or /sample_submissions.json
  def create
    @sample_submission = SampleSubmission.new(sample_submission_params)
    # @sample_submission.sample.attach(io: File.open('/public'), filename: "#{SampleSubmission.maximum(:id).next}.jpg")
    new_file_name = "#{SampleSubmission.maximum(:id) || 1}.jpg"
    (@sample_submission.sample.styles.keys).each do |style|
      path = @sample_submission.sample.path(style)
      FileUtils.move(path, File.join(File.dirname(path), new_file_name))
    end
    p new_file_name
    @sample_submission.sample_file_name = new_file_name

    respond_to do |format|
      if @sample_submission.save

        require 'net/http'
        source = "http://localhost:5000?name=#{new_file_name}"
        resp = Net::HTTP.get_response(URI.parse(source))
        data = resp.body
        result = JSON.parse(data)
        p '--------'
        p result
        p result["result"]

        @sample_submission.update(sample_response:result["result"])
        format.html { redirect_to sample_submission_url(@sample_submission), notice: "Sample submission was successfully created." }
        format.json { render :index, status: :created, location: @sample_submission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sample_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sample_submissions/1 or /sample_submissions/1.json
  def update
    respond_to do |format|
      if @sample_submission.update(sample_submission_params)
        format.html { redirect_to sample_submission_url(@sample_submission), notice: "Sample submission was successfully updated." }
        format.json { render :show, status: :ok, location: @sample_submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sample_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sample_submissions/1 or /sample_submissions/1.json
  def destroy
    @sample_submission.destroy

    respond_to do |format|
      format.html { redirect_to sample_submissions_url, notice: "Sample submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_sample_submission
    @sample_submission = SampleSubmission.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def sample_submission_params
    params.fetch(:sample_submission, {}).permit(:name, :age, :mobile, :gender, :address, :sample,:sample_response)
  end
end
