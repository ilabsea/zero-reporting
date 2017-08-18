class UserCSV
  def initialize(csv_string)
    @csv_string = CSV.parse(csv_string)
    @users = {}
  end

  def import
    data = []
    @csv_string.each_with_index do |item, index|
      next if index == 0
      place = Place.find_by_code(item[6].strip)
      user = User.create!(
          username: item[0],
          name: item[1],
          email: item[2],
          phone: item[3],
          role: "Normal",
          place_id: place.id,
          password: item[4],
          password_confirmation: item[5]
      )
      data.push(user)
    end
    return {data: data, row_imported: data.length}
  end

  def decode
    parse_with_validation
  end

  def validate_password_confirmation(password, password_confirmation)
    return (password == password_confirmation) ? true : false
  end

  def parse_with_validation
    @csv_string.each_with_index do |row, index|
      next if index == 0
      item = {}
      item[:ord] = index
      item[:errors] = []

      if(valid_csv_column?(row))
        login_name = row[0].strip if row[0].present?
        full_name = row[1].strip if row[1].present?
        email = row[2].strip if row[2].present?
        phone_number = row[3].strip if row[3].present?
        password = row[4].strip if row[4].present?
        password_confirmation = row[5].strip if row[5].present?
        item[:email] = email

        if(login_name.present?)
          item[:login_name] = login_name
        else
          item[:errors].push({:type => 'missing', :field => 'login_name'})
        end

        if(full_name.present?)
          item[:full_name] = full_name
        else
          item[:errors].push({:type => 'missing', :field => 'full_name'})
        end

        if(phone_number.present?)
          item[:phone_number] = phone_number
        else
          item[:errors].push({:type => 'missing', :field => 'phone_number'})
        end

        if(password.present? && password_confirmation.present?)
          if(validate_password_confirmation(password, password_confirmation))
            item[:password] = password
            item[:password_confirmation] = password
          else
            item[:errors].push({:type => 'not_match', :field => 'password'})
          end
        else
          item[:errors].push({:type => 'missing', :field => 'password'})
        end

        location_code = row[6].strip if row[6].present?
        if(location_code.present?)
          place = Place.find_by_code(location_code)
          if place
            item[:location_code] = "#{place.name}(#{place.code}) - #{place.kind_of}"
          else
            item[:location_code] = ''
            item[:errors].push({:type => 'unknown', :field => 'place'})
          end
        else
          item[:errors].push({:type => 'missing', :field => 'place'})
        end
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
