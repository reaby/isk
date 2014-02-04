class AddThrashGroupsStiModel < ActiveRecord::Migration
  def up
		Event.transaction do
			Event.all.each do |e|
				g = MasterGroup.find(e.thrashed_id)
				g.type = ThrashGroup.sti_name
				g.save!
			end
		end
  end

  def down
		Event.transaction do
			Event.all.each do |e|
				g = MasterGroup.find(e.thrashed_id)
				g.type = MasterGroup.sti_name
				g.save!
			end
		end
  end
end