class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.references :project
      t.integer :member
      t.string :check_payable
      t.string :mailing_address
      t.string :phone
      t.text :planning_team
      t.text :serviced
      t.text :goals
      t.text :funds_use
      t.text :partnerships
      t.text :resources
      t.timestamps
    end
  end
end
