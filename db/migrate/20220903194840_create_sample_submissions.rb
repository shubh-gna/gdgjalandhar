class CreateSampleSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :sample_submissions do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.integer :mobile
      t.string :address
      t.attachment :sample
      t.string :sample_response

      t.timestamps
    end
  end
end
