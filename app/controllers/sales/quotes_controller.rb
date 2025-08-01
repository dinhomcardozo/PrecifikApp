class Sales::QuotesController < ApplicationController
  before_action :set_sales_quote, only: %i[ show edit update destroy ]

  # GET /sales/quotes or /sales/quotes.json
  def index
    @sales_quotes = Sales::Quote.all
  end

  # GET /sales/quotes/1 or /sales/quotes/1.json
  def show
  end

  # GET /sales/quotes/new
  def new
    @sales_quote = Sales::Quote.new
  end

  # GET /sales/quotes/1/edit
  def edit
  end

  # POST /sales/quotes or /sales/quotes.json
  def create
    @sales_quote = Sales::Quote.new(sales_quote_params)

    respond_to do |format|
      if @sales_quote.save
        format.html { redirect_to @sales_quote, notice: "Quote was successfully created." }
        format.json { render :show, status: :created, location: @sales_quote }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sales_quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/quotes/1 or /sales/quotes/1.json
  def update
    respond_to do |format|
      if @sales_quote.update(sales_quote_params)
        format.html { redirect_to @sales_quote, notice: "Quote was successfully updated." }
        format.json { render :show, status: :ok, location: @sales_quote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sales_quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/quotes/1 or /sales/quotes/1.json
  def destroy
    @sales_quote.destroy!

    respond_to do |format|
      format.html { redirect_to sales_quotes_path, status: :see_other, notice: "Quote was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_quote
      @sales_quote = Sales::Quote.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sales_quote_params
      params.expect(sales_quote: [ : client_id, : channel_cost, : bank_slip_cost, : card_cost, : status, : total ])
    end
end
