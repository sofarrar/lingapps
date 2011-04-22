class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.references :source
      t.references :target

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
