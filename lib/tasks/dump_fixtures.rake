namespace :db do
    desc "Dump table data to fixtures"
    task dump_fixtures: :environment do
      dir = Rails.root.join('test', 'fixtures')
      FileUtils.mkdir_p(dir)
  
      ActiveRecord::Base.connection.tables.each_with_index do |table, index|
        next if table == 'schema_migrations'  # Skip schema_migrations table
  
        file_path = dir.join("#{table}.yml")
  
        # Fetch records from the table
        records = ActiveRecord::Base.connection.execute("SELECT * FROM #{table}")
  
        # Open the YAML file for writing
        File.open(file_path, 'w') do |file|
          table_data = {}
  
          # Iterate over each record and create fixtures with letters 'a', 'b', 'c', etc. as keys
          records.each_with_index do |record, record_index|
            # Convert the record hash into a format that Rails expects for fixtures
            fixture_record = record.transform_keys(&:to_s).transform_values do |value|
              # Ensure that NULL values are properly handled as nil
              if value.nil?
                nil
              elsif value.is_a?(String) && value.match?(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)
                # Convert timestamps to format like 2024-05-27 21:15:42.757457000 Z
                value + ' Z'
              else
                value
              end
            end
  
            # Explicitly set the id field for the fixture
            fixture_record['id'] = record['id'].to_s
  
            # Use letters like 'a', 'b', 'c', etc. as keys
            fixture_key = ('a'.ord + record_index).chr
  
            # Store the record in a hash where the key is the letter
            table_data[fixture_key] = fixture_record
          end
  
          # Write the formatted data to the YAML file
          file.write(table_data.to_yaml)
  
          puts "Dumped #{table} to #{file_path}"
        end
      end
    end
  end
  