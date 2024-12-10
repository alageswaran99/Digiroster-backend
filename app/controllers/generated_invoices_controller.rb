class GeneratedInvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy]
  before_action :validate_params, only: [:create, :update, :cancel_invoice]

  # POST /api/generatedInvoices/create
  def create
    invoice_params = invoice_params.merge(account_id: current_account.id)

    # Check if an invoice already exists for this client and time period
    existing_invoice = Invoice.find_by(clientId: invoice_params[:clientId], timePeriod: invoice_params[:timePeriod])
    if existing_invoice
      render json: { error: 'Invoice already generated for this time period. You can edit the existing invoice.' }, status: :unprocessable_entity
      return
    end

    @invoice = Invoice.new(invoice_params)

    # Save invoice and create associated items
    if @invoice.save
      create_invoice_items(@invoice, params[:items])
      @invoice.calculate_total_amount
      @invoice.save

      render json: @invoice, status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # GET /api/generatedInvoices
  def index
    # Optional filter logic similar to appointments
    if params[:filter].present?
      @invoices = scoper
      handle_filter
    else
      @invoices = scoper.all
    end

    render json: @invoices
  end

  # PUT /api/generatedInvoices/update/:invoiceId
  def update
    if @invoice.update(invoice_params)
      update_invoice_items(@invoice, params[:items])
      @invoice.calculate_total_amount
      @invoice.save

      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/generatedInvoices/:invoiceId
  def destroy
    if @invoice.destroy
      head 204
    else
      render json: { error: 'Invoice could not be deleted' }, status: :unprocessable_entity
    end
  end

  # POST /api/generatedInvoices/cancel/:invoiceId
  def cancel_invoice
    if @invoice.update(status: 'canceled')
      render json: { message: 'Invoice canceled successfully' }, status: :ok
    else
      render json: { error: 'Invoice cancellation failed' }, status: :unprocessable_entity
    end
  end

  private

  # Fetch the invoice by ID (using invoiceId instead of ID)
  def set_invoice
    @invoice = Invoice.find_by(invoiceId: params[:invoiceId])
    render json: { error: 'Invoice not found' }, status: :not_found unless @invoice
  end

  # Invoice parameters to be passed for creation or update
  def invoice_params
    params.require(:invoice).permit(
      :invoiceId, :clientId, :groupId, :regionId, :timePeriod, :durationtype,
      :customizedCheckbox, :ratePerMinute, :invoiceDate
    )
  end

  # Create invoice items for a given invoice
  def create_invoice_items(invoice, items)
    items.each do |item|
      invoice.invoice_items.create(
        date: item[:date],
        quantity: item[:quantity],
        description: item[:description],
        unitPrice: item[:unitPrice],
        amount: item[:amount]
      )
    end
  end

  # Update invoice items (by deleting old ones and creating new ones)
  def update_invoice_items(invoice, items)
    invoice.invoice_items.delete_all
    create_invoice_items(invoice, items)
  end

  # Apply filters to the invoice records if needed
  def handle_filter
    params[:filter].each do |key, value|
      @invoices = @invoices.safe_send(key, value)
    end
  end

  # Scoper method for invoice data retrieval
  def scoper
    current_account.invoices.includes([:client, :items])
  end

  # Validate parameters before creating or updating
  def validate_params
    # Custom validation logic can be added here, for example:
    unless params[:invoice][:clientId].present? && params[:invoice][:timePeriod].present?
      render json: { error: 'Client ID and Time Period are required' }, status: :unprocessable_entity
    end
  end
end
