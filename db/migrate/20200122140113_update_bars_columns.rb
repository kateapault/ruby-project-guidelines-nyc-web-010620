class UpdateBarsColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :bars, :business_name, :string
    add_column :bars, :address_city, :string
    add_column :bars, :address_zip, :string
    add_column :bars, :contact_number, :string
  end
end
