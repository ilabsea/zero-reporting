class UserCSV
  def initialize(csv_string)
    @csv_string = CSV.parse(csv_string)
    @users = {}
  end

  def self.sample
    content = "login,full_name,email,phone_number,password,password_confirmation,location_code \n"
    2.times.each do |i|
      content = content + "example_#{i},example user_#{i},example_#{i}@sampledomain.org.kh,85512344323#{i},samplepassword,samplepassword,100#{i} \n"
    end
    content
  end

  def import
    data = []
    row_imported = 0
    @csv_string.each_with_index do |item, index|
      next if index == 0
      place = Place.find_by_code(item[6].strip)
      user = User.new(
          username: item[0],
          name: item[1],
          email: item[2],
          phone: item[3],
          role: "Normal",
          place_id: place.id,
          password: item[4],
          password_confirmation: item[5]
      )
      if(user.save)
        data.push(user)
        row_imported = row_imported + 1
      end
    end
    return {data: data, row_imported: row_imported}
  end

  def decode
    parse_with_validation
  end

  private
  def parse_with_validation
    @csv_string.each_with_index do |row, index|
      next if index == 0
      item = {}
      item[:ord] = index
      item[:errors] = []
      valid = false

      if(valid_csv_column?(row))
        user = {}
        user[:username] = row[0].strip if row[0].present?
        user[:name] = row[1].strip if row[1].present?
        user[:email] = row[2].strip if row[2].present?
        user[:phone] = row[3].strip if row[3].present?
        user[:password] = row[4].strip if row[4].present?
        user[:password_confirmation] = row[5].strip if row[5].present?
        user[:place_id] = row[6].strip if row[6].present?

        new_user = User.new(user)
        place = Place.find_by_code(user[:place_id])
        item[:location_code] = place ? "#{place.name}(#{place.code}) - #{place.kind_of}" : ''
        item[:errors].push(new_user.errors.messages) if !new_user.valid?
        item = item.merge(user)

      else
        item[:errors].push({:type => 'invalid column number', :field => 'format'})
      end
      @users[item[:ord]] = item
    end

    @users

  end

  def valid_csv_column?(item)
    return item.length == 7 ? true : false
  end

end
