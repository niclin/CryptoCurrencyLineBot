class CreateDailyNews < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_news do |t|
      t.text :content
      t.string :url

      t.timestamps
    end
  end
end
