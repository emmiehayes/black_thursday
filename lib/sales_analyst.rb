# frozen_string_literal: false

require 'pry'
# responsible for database query
class SalesAnalyst

  def initialize(engine)
    @engine = engine
    @items = @engine.items
    @merchants = @engine.merchants
    @invoices = @engine.invoices
    @transactions = @engine.transactions
    @invoice_items = @engine.invoice_items
    @customers = @engine.customers
  end

  def mean(numbers_array) # HELPER
    (numbers_array.inject(:+).to_f / numbers_array.count).round(2)
  end

  def summed_variance(numbers_array) # HELPER
    avg = mean(numbers_array)
    numbers_array.map do |count|
      (count - avg)**2
    end.inject(:+)
  end

  def standard_deviation(numbers_array) # HELPER
    result = (summed_variance(numbers_array) / (numbers_array.count - 1))
    Math.sqrt(result).round(2)
  end

  def average_items_per_merchant # req
    mean(item_count_for_each_merchant_id.values)
  end

  def average_items_per_merchant_standard_deviation # req
    standard_deviation(item_count_for_each_merchant_id.values)
  end

  def one_deviation # HELPER
    average_items_per_merchant + average_items_per_merchant_standard_deviation
  end

  def item_count_for_each_merchant_id # HELPER
    grouped_items = items_group_by_merchant_id
    grouped_items.merge(grouped_items) do |_, item_list|
      item_list.count
    end
  end

  def merchants_with_high_item_count #req
    item_count_for_each_merchant_id.map do |merchant_id, item_count|
      @merchants.find_by_id(merchant_id) if item_count > one_deviation
    end.compact
  end

  def items_group_by_merchant_id # HELPER
    @items.all.group_by(&:merchant_id)
  end

  def average_item_price_for_merchant(merchant_id) #req
    prices = items_group_by_merchant_id[merchant_id].map(&:unit_price)
    BigDecimal(mean(prices), 6)
  end

  def average_average_price_per_merchant #req
    avg_prices = items_group_by_merchant_id.map do |merchant_id, _|
      average_item_price_for_merchant(merchant_id)
    end
    BigDecimal(mean(avg_prices), 6)
  end

  def all_item_unit_prices # HELPER
    @items.all.map(&:unit_price)
  end

  def average_item_unit_price # HELPER
    mean(all_item_unit_prices)
  end

  def average_item_unit_price_standard_deviation # HELPER
    standard_deviation(all_item_unit_prices)
  end

  def golden_deviation # HELPER
    average_item_unit_price +
    (average_item_unit_price_standard_deviation * 2)
  end

  def golden_items #req
    @items.all.map do |item|
      item if item.unit_price > golden_deviation
    end.compact
  end

  def invoices_group_by_merchant_id # HELPER
    @invoices.all.group_by(&:merchant_id)
  end

  def invoice_count_for_each_merchant_id # HELPER
    grouped_invoices = invoices_group_by_merchant_id
    grouped_invoices.merge(grouped_invoices) do |_ , invoice_list|
      invoice_list.count
    end
  end

  def average_invoices_per_merchant #req
    mean(invoice_count_for_each_merchant_id.values)
  end

  def average_invoices_per_merchant_standard_deviation #req
    standard_deviation(invoice_count_for_each_merchant_id.values)
  end

  def double_deviation # HELPER
    average_invoices_per_merchant +
    (average_invoices_per_merchant_standard_deviation * 2)
  end

  def top_merchants_by_invoice_count # req
    invoice_count_for_each_merchant_id.map do |merchant_id, invoice_count|
      @merchants.find_by_id(merchant_id) if invoice_count > double_deviation
    end.compact
  end

  def bottom_merchants_by_invoice_count # req
    invoice_count_for_each_merchant_id.map do |merchant_id, invoice_count|
      @merchants.find_by_id(merchant_id) if invoice_count < double_deviation
    end.compact
  end

  def invoices_group_by_day # HELPER
    @invoices.all.group_by do |invoice|
      invoice.created_at.wday
    end
  end

  def invoice_count_by_weekday # HELPER
    invoices_group_by_day.map do |day, invoices|
      if day.zero?
        day, invoices = 'Sunday', invoices.count
      elsif day == 1
        day, invoices = 'Monday', invoices.count
      elsif day == 2
        day, invoices = 'Tuesday', invoices.count
      elsif day == 3
        day, invoices = 'Wednesday', invoices.count
      elsif day == 4
        day, invoices = 'Thursday', invoices.count
      elsif day == 5
        day, invoices = 'Friday', invoices.count
      elsif day == 6
        day, invoices = 'Saturday', invoices.count
      end
    end.to_h
  end

  def average_invoice_count_per_weekday # HELPER
    mean(invoice_count_by_weekday.values)
  end

  def average_invoice_count_per_weekday_standard_deviation # HELPER
    standard_deviation(invoice_count_by_weekday.values)
  end

  def weekday_deviation # HELPER
    average_invoice_count_per_weekday +
    average_invoice_count_per_weekday_standard_deviation
  end

  def top_days_by_invoice_count # req
    invoice_count_by_weekday.map do |day, count|
      day if count > weekday_deviation
    end.compact
  end

  def invoices_group_by_status # HELPER
    @invoices.all.group_by(&:status)
  end

  def percentage(numbers) # HELPER
    (100 * numbers.count / @invoices.all.count.to_f).round(2)
  end

  def invoice_count_by_status # HELPER
    invoices_group_by_status.map do |status, invoices|
      status, invoices = status, percentage(invoices)
    end.to_h
  end

  def invoice_status(status) # req
    invoice_count_by_status[status]
  end

  def transactions_group_by_invoice_id # HELPER
    @transactions.all.group_by(&:invoice_id)
  end

  def invoice_paid_in_full?(invoice_id) # req
    return false if transactions_group_by_invoice_id[invoice_id].nil?
    transactions_group_by_invoice_id[invoice_id].any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_items_group_by_invoice_id # HELPER
    @invoice_items.all.group_by(&:invoice_id)
  end

  def invoice_total(invoice_id) # req
    invoice_items_group_by_invoice_id[invoice_id].map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end.inject(:+)
  end

  def invoices_group_by_customer # HELPER
    @invoices.all.group_by(&:customer_id)
  end
end
