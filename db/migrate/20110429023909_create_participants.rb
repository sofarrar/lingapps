class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :role
      t.string :name
	    t.integer :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
