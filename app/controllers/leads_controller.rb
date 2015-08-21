class LeadsController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:index, :show, :new, :edit]

  # GET /leads
  # GET /leads.json
  def index
    @leads = Lead.all
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
  end

  # GET /leads/new
  def new

  end

  # GET /leads/1/edit
  def edit
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.where(email: lead_params[:email]).first_or_initialize
    @lead.assign_attributes(lead_params)

    respond_to do |format|
      if @lead.save

        if (@lead.platform == "Bigcommerce")
          LeadMailer.delay.sign_up_platform_exists(@lead.id)
        elsif (@lead.platform == "Custom")
          LeadMailer.delay.sign_up_platform_custom(@lead.id)
        else 
          LeadMailer.delay.sign_up_platform_does_not_exist(@lead.id)
        end
        
        format.html { redirect_to controller: "pages", action: "thank_you"}
      else
        format.html { redirect_to :back, notice: "That's not even an email address, is it?"}
      end
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:email, :platform)
    end
end
