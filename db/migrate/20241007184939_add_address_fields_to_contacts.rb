class AddAddressFieldsToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :street, :string
    add_column :contacts, :number, :string
    add_column :contacts, :complement, :string
    add_column :contacts, :neighborhood, :string
    add_column :contacts, :cep, :string
    add_column :contacts, :latitude, :float
    add_column :contacts, :longitude, :float
  end
end
