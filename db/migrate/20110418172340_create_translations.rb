class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
		t.integer :project_id
      t.references :source
      t.references :target

      t.timestamps
    end
	add_index :translations, :project_id
  end

  def self.down
    drop_table :translations
  end
end
