class RemoveAddressFromContacts < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :address, :string
  end
end
