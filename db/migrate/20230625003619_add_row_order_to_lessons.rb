class AddRowOrderToLessons < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :row_order, :integer
    Lesson.update_all('row_order = EXTRACT(EPOCH FROM created_at)')
  end
end
