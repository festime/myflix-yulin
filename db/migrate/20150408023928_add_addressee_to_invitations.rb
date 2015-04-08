class AddAddresseeToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :addressee_name, :string
  end
end
