class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
		t.integer :local_id
		t.integer :project_id
		t.boolean :deleted, :default => false
		t.string :pos
		t.string :tags
		t.string :notes
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
