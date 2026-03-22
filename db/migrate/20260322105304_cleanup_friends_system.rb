class CleanupFriendsSystem < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    # ========================
    # BOOKINGS CLEANUP
    # ========================
    if column_exists?(:bookings, :partner_friend_id)
      remove_column :bookings, :partner_friend_id
    end

    # ========================
    # REMOVE FRIENDS TABLE
    # ========================
    drop_table :friends, if_exists: true

    # ========================
    # FIX FRIENDSHIPS FK
    # ========================
    if foreign_key_exists?(:friendships, column: :friend_id)
      remove_foreign_key :friendships, column: :friend_id
    end

    add_foreign_key :friendships, :users, column: :friend_id
  end
end
