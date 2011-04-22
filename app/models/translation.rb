class Translation < ActiveRecord::Base
  belongs_to :source, :class_name => "Expression", :foreign_key => "source_id"
  belongs_to :target, :class_name => "Expression", :foreign_key => "target_id"
end
