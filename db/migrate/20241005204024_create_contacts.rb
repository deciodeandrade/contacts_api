class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :cpf
      t.string :address
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
