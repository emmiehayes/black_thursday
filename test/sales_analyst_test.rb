require_relative 'test_helper'
require './lib/sales_engine'
require './lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def setup
    @sales_engine = SalesEngine.from_csv({
      :items     => './data/items.csv',
      :merchants => './data/merchants.csv',
      :invoices => './data/invoices.csv',
      :transactions => './data/transactions.csv',
      :invoice_items => './data/invoice_items.csv',
      :customers => './data/customers.csv'
    })
    @sales_analyst = @sales_engine.analyst
    @merchant_repository = @sales_engine.merchants
    @item_repository = @sales_engine.items
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, @sales_analyst
  end
  #
  # def test_mean_calculation
  #   assert_equal 5.25, @sales_analyst.mean([4, 6, 5, 6])
  # end
  #
  # def test_summed_variance_calculation
  #   assert_equal 5.0, @sales_analyst.summed_variance([4, 5, 6, 7])
  # end
  #
  # def test_standard_deviation_calculation
  #   assert_equal 2.3, @sales_analyst.standard_deviation([4, 5, 6, 7, 10])
  # end
  #
  # def test_average_items_per_merchant
  #   assert_equal 2.88, @sales_analyst.average_items_per_merchant
  # end
  #
  # def test_average_items_per_merchant_standard_deviation
  #   actual = @sales_analyst.average_items_per_merchant_standard_deviation
  #   assert_equal 3.26, actual
  # end
  #
  # def test_it_can_return_all_item_unit_prices
  #   assert_instance_of Array, @sales_analyst.all_item_unit_prices
  #   assert_equal 1367, @sales_analyst.all_item_unit_prices.count
  # end
  #
  # def test_merchants_with_high_item_count
  #   assert @sales_analyst.merchants_with_high_item_count.all? do |element|
  #     Merchant == element.class
  #   end
  #   assert_equal 52, @sales_analyst.merchants_with_high_item_count.count
  # end
  #
  # def test_calculates_average_item_price_for_merchant
  #   actual = @sales_analyst.average_item_price_for_merchant(12334783)
  #   assert_equal BigDecimal(47.5, 3), actual
  # end
  #
  # def test_calculate_average_average_item_price_for_merchant
  #   actual = @sales_analyst.average_average_price_per_merchant
  #   assert_equal 350.29, actual
  # end
  #
  # def test_it_can_find_all_golden_items
  #   assert @sales_analyst.golden_items.all? do |element|
  #     Item == element.class
  #   end
  #   assert_equal 5, @sales_analyst.golden_items.count
  # end
  #
  # def test_it_can_calculate_average_invoices_per_merchant
  #   assert_equal 10.49, @sales_analyst.average_invoices_per_merchant
  # end
  #
  # def test_average_invoices_per_merchant_standard_deviation
  #   actual = @sales_analyst.average_invoices_per_merchant_standard_deviation
  #   assert_equal 3.29, actual
  # end
  #
  # def test_it_can_determine_top_merchants_by_invoice_count
  #   assert @sales_analyst.top_merchants_by_invoice_count.all? do |element|
  #     Merchant == element.class
  #   end
  #   assert_equal 12, @sales_analyst.top_merchants_by_invoice_count.count
  # end
  #
  # def test_it_can_determine_top_merchants_by_invoice_count
  #   assert @sales_analyst.bottom_merchants_by_invoice_count.all? do |element|
  #     Merchant == element.class
  #   end
  #   # assert_equal 463, @sales_analyst.bottom_merchants_by_invoice_count.count
  # end
  #
  # def test_it_can_group_by_day
  #   assert_equal 7, @sales_analyst.invoices_grouped_by_day.keys.count
  # end
  #
  # def test_invoice_count_by_weekday
  #   assert_equal 7, @sales_analyst.invoice_count_by_weekday.keys.count
  # end
  #
  # def test_average_invoice_count_per_weekday
  #   assert_equal 712.14, @sales_analyst.average_invoice_count_per_weekday
  # end
  #
  # def test_average_invoice_count_per_weekday_standard_deviation
  #   assert_equal 18.07, @sales_analyst.average_invoice_count_per_weekday_standard_deviation
  # end
  #
  # def test_top_days_by_invoice_count
  #   assert_equal ['Wednesday'], @sales_analyst.top_days_by_invoice_count
  # end
  #
  # def test_invoice_count_by_status
  #   expected = {:pending=>29.55, :shipped=>56.95, :returned=>13.5}
  #   assert_equal expected, @sales_analyst.invoice_count_by_status
  # end
  #
  # def test_invoice_status
  #   assert_equal 29.55, @sales_analyst.invoice_status(:pending)
  #   assert_equal 56.95, @sales_analyst.invoice_status(:shipped)
  #   assert_equal 13.5, @sales_analyst.invoice_status(:returned)
  # end

  # def test_it_can_find_a_transaction_by_invoice_id
  #   actual = @sales_analyst.find_transaction_by_invoice_id(8).credit_card_number
  #   assert_equal '4352959538224312', actual
  # end
  #
  # def test_invoice_paid_in_full
  #   assert @sales_analyst.invoice_paid_in_full?(8)
  #   refute @sales_analyst.invoice_paid_in_full?(105)
  # end

  # def test_it_can_find_all_invoice_items_by_invoice_id
  #   assert_equal 8, @sales_analyst.find_invoice_items(1).count
  #   assert @sales_analyst.find_invoice_items(1).all? do |element|
  #     InvoiceItem == element.class && element.invoice_id == 1
  #   end
  # end

  # def test_it_can_return_the_total_dollars_for_given_invoice_id
  #   assert_equal 21_067.77 , @sales_analyst.invoice_total(1)
  #   assert_instance_of BigDecimal, @sales_analyst.invoice_total(1)
  # end
  #
  # def test_it_can_find_all_invoices_per_customer_id
  #   assert @sales_analyst.invoices_per_customer(4).all? do |element|
  #     Customer == element.class && element.customer_id == 4
  #   end
  #   assert_instance_of Array, @sales_analyst.invoices_per_customer(4)
  # end
  #
  # def test_it_can_find_total_spend_for_a_given_customer
  #   assert @sales_analyst.total_customer_spend.all? do |element|
  #     Customer == element[0].class
  #   end
  #   assert @sales_analyst.total_customer_spend.all? do |element|
  #     BigDecimal == element[1].class
  #   end
  # end

  # def test_it_can_sort_customers_from_highest_spending_to_lowest
  #   first = @sales_analyst.sorted_customers_by_spend[0][1]
  #   second = @sales_analyst.sorted_customers_by_spend[1][1]
  #   assert first > second
  #   actual = @sales_analyst.sorted_customers_by_spend[0][0].first_name
  #     assert_equal 'Mazie', actual
  # end

  # def test_it_can_find_top_x_buyers
  #   assert_equal 5, @sales_analyst.top_buyers(5).length
  #   assert_equal 313, @sales_analyst.top_buyers(5).first.id
  #   assert_equal 478, @sales_analyst.top_buyers(5).last.id
  #   assert_equal 20, @sales_analyst.top_buyers.length
  # end

  
end
