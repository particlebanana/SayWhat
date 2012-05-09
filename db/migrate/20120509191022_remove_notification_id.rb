class RemoveNotificationId < ActiveRecord::Migration
  def up
    remove_column :memberships, :notification
  end

  def down
    add_column :memberships, :notification, :string
  end
end
