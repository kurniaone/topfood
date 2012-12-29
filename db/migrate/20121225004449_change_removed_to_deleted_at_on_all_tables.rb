class ChangeRemovedToDeletedAtOnAllTables < ActiveRecord::Migration
  def up
    tables = ActiveRecord::Base.connection.tables - ["schema_migrations"]
    tables.each do |table|
      if column_exists?(table, :removed)
        rename_column(table, :removed, :deleted_at)
        change_column(table, :deleted_at, :datetime, :default => nil)
        ActiveRecord::Base.connection.execute("UPDATE #{table} SET deleted_at = NULL")
      end
    end
  end

  def down
    tables = ActiveRecord::Base.connection.tables - ["schema_migrations"]
    tables.each do |table|
      if column_exists?(table, :deleted_at)
        rename_column(table, :deleted_at, :removed)
        change_column(table, :removed, :boolean, :default => false)
      end
    end
  end
end
