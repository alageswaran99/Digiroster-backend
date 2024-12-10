class Api::GeneratedInvoicesController < ApplicationController
  before_action :set_invoice, only: [:update]

  # POST /api/generatedInvoices/create
  def create
    invoice_params = invoice_params.merge(account_id: current_account.id)

    existing_invoice = Invoice.find_by(clientId: invoice_params[:clientId], timePeriod: invoice_params[:timePeriod])
    if existing_invoice
      render json: { error: 'Invoice already generated for this time period. You can edit the existing invoice.' }, status: :unprocessable_entity
      return
    end

    @invoice = Invoice.new(invoice_params)
    
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
    @invoices = Invoice.all
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

  private

  def set_invoice
    @invoice = Invoice.find_by(invoiceId: params[:invoiceId])
    render json: { error: 'Invoice not found' }, status: :not_found unless @invoice
  end

  def invoice_params
    params.require(:invoice).permit(
      :invoiceId, :clientId, :groupId, :regionId, :timePeriod, :durationtype,
      :customizedCheckbox, :ratePerMinute, :invoiceDate
    )
  end

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

  def update_invoice_items(invoice, items)
    invoice.invoice_items.delete_all
    create_invoice_items(invoice, items)
  end
end
