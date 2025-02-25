class AddExcludedToAiMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :ai_messages, :excluded, :boolean, default: false
  end
end
