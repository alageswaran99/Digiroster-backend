class GeneratedInvoicesController < ApplicationController
  # POST /api/generatedInvoices/create
  def create

    byebug
    invoice_params_data = invoice_params || {}
    merged_params = invoice_params_data.merge(account_id: current_account.id)

    # Log merged params
    Rails.logger.debug("Merged params: #{merged_params}")

    # Check if an invoice already exists
    existing_invoice = Invoice.find_by(clientId: merged_params[:clientId], timePeriod: merged_params[:timePeriod])
    if existing_invoice
      render json: { error: 'Invoice already generated for this time period. You can edit the existing invoice.' }, status: :unprocessable_entity
      return
    end

    # Generate a new invoice ID if not provided
    merged_params[:invoiceId] ||= SecureRandom.uuid

    @invoice = Invoice.new(merged_params)

    # Save the invoice and create its items
    if @invoice.save
      create_invoice_items(@invoice, params[:items] || [])
      @invoice.calculate_total_amount
      @invoice.save

      render json: @invoice, status: :created
    else
      Rails.logger.error("Invoice save failed: #{@invoice.errors.full_messages}")
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params[:invoice]&.permit(
      :invoiceId, :clientId, :groupId, :regionId, :timePeriod, :fromDate, :toDate,
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
end
