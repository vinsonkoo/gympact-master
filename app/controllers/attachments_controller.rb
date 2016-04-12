class AttachmentsController < InheritedResources::Base

  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  # GET /attachments
  # GET /attachments.json
  def index
    @pact = Pact.find(params[:pact_id])
    @attachments = @pact.attachments.all
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @pact = Pact.find(params[:pact_id])
    @attachment = Pact.attachment.find_by(params[:id])
  end

  # GET /attachments/new
  def new
    @pact = Pact.find(params[:pact_id])
    @attachment = Attachment.new
  end

  # GET /attachments/1/edit
  def edit
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.save

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment.post, notice: 'Attachment was successfully updated.' }
      end 
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: 'Pact attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    def attachment_params
      params.require(:attachment).permit(:pact_id, :filename)
    end
end

