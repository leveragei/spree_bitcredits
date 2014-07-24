class CreateSpreeBitCreditsCheckouts < ActiveRecord::Migration
  def up
    unless ActiveRecord::Base.connection.table_exists? 'spree_bit_credits_checkouts'
      create_table :bit_credits_checkouts do |t|
        t.float :old_balance
        t.float :new_balance
        t.string :source
        t.integer :tx_id
      end
    end
  end

  def down
    drop_table :bit_credits_checkouts if ActiveRecord::Base.connection.table_exists? 'spree_bit_credits_checkouts'
  end
end
