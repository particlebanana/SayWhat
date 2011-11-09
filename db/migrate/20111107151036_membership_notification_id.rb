class MembershipNotificationId < ActiveRecord::Migration
  def up
    add_column :memberships, :notification, :string
  end

  def down
    remove_column :memberships, :notification
  end
end
