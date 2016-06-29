require 'rails_helper'

RSpec.describe "products/edit", type: :view do
  before(:each) do
    @product = assign(:product, Product.create!(
      :name => "MyString",
      :sku => "MyString",
      :price => 1,
      :credits => 1,
      :quantity => 1
    ))
  end

  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", product_path(@product), "post" do

      assert_select "input#product_name[name=?]", "product[name]"

      assert_select "input#product_sku[name=?]", "product[sku]"

      assert_select "input#product_price[name=?]", "product[price]"

      assert_select "input#product_credits[name=?]", "product[credits]"

      assert_select "input#product_quantity[name=?]", "product[quantity]"
    end
  end
end
