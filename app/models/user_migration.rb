class UserMigration
  def self.migrate_reportable
    User.transaction do
      User.find_each(batch_size: 100) do |user|
        next if user.place.nil?
        user.reportable = user.place.kind_of == HC.kind ? true : false
        user.save
      end
    end
  end
end
