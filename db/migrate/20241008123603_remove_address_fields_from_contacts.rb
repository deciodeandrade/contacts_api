class RemoveAddressFieldsFromContacts < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :street, :string
    remove_column :contacts, :number, :string
    remove_column :contacts, :complement, :string
    remove_column :contacts, :neighborhood, :string
    remove_column :contacts, :city, :string
    remove_column :contacts, :state, :string
    remove_column :contacts, :cep, :string
    remove_column :contacts, :latitude, :float
    remove_column :contacts, :longitude, :float
  end
end
