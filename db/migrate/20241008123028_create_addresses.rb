class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :cep
      t.float :latitude
      t.float :longitude
      t.references :contact, null: false, foreign_key: true

      t.timestamps
    end
  end
end
