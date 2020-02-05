#These functions are barely tested and temporary, they should be removed when the results page is filtering in Rails
module CsharpRailsSubjectConversionHelper
  def convert_csharp_subject_id_params_to_rails
    deserialize_array_filter_param("subjects")&.map do |subject|
      csharp_to_rails_subject_id(id: subject)
    end
  end

  def convert_rails_subject_id_params_to_csharp
    new_subjects = params["subjects"]&.map do |subject|
      rails_to_csharp_subject_id(id: subject)
    end

    serialize_array_filter_param(new_subjects)
  end

  def csharp_to_rails_subject_id(id:)
    rails_data = csharp_rails_conversion_table.find do |entry|
      entry[:csharp_id] == id
    end

    raise "An unregistered subject id was specified: #{id}" if rails_data.nil?

    rails_data[:rails_id]
  end

  def rails_to_csharp_subject_id(id:)
    csharp_data = csharp_rails_conversion_table.find do |entry|
      entry[:rails_id] == id
    end

    raise "An unregistered subject id was specified: #{id}" if csharp_data.nil?

    csharp_data[:csharp_id]
  end

  def csharp_rails_conversion_table
    [{ csharp_id: nil, rails_id: "27", name: "Philosophy" },
     { csharp_id: nil, rails_id: "33", name: "Modern Languages" },
     { csharp_id: "49", rails_id: "42", name: "Modern languages (other)" },
     { csharp_id: "14", rails_id: "43", name: "Further education" },
     { csharp_id: "44", rails_id: "41", name: "Spanish" },
     { csharp_id: "41", rails_id: "40", name: "Russian" },
     { csharp_id: "23", rails_id: "39", name: "Mandarin" },
     { csharp_id: "21", rails_id: "38", name: "Japanese" },
     { csharp_id: "20", rails_id: "37", name: "Italian" },
     { csharp_id: "16", rails_id: "36", name: "German" },
     { csharp_id: "53", rails_id: "35", name: "English as a second or other language" },
     { csharp_id: "13", rails_id: "34", name: "French" },
     { csharp_id: "43", rails_id: "32", name: "Social sciences" },
     { csharp_id: "40", rails_id: "31", name: "Religious education" },
     { csharp_id: "39", rails_id: "30", name: "Psychology" },
     { csharp_id: "30", rails_id: "29", name: "Physics" },
     { csharp_id: "29", rails_id: "28", name: "Physical education" },
     { csharp_id: "27", rails_id: "26", name: "Music" },
     { csharp_id: "24", rails_id: "25", name: "Mathematics" },
     { csharp_id: "18", rails_id: "24", name: "History" },
     { csharp_id: "17", rails_id: "23", name: "Health and social care" },
     { csharp_id: "15", rails_id: "22", name: "Geography" },
     { csharp_id: "12", rails_id: "21", name: "English" },
     { csharp_id: "11", rails_id: "20", name: "Economics" },
     { csharp_id: "9", rails_id: "19", name: "Drama" },
     { csharp_id: "8", rails_id: "18", name: "Design and technology" },
     { csharp_id: "7", rails_id: "17", name: "Dance" },
     { csharp_id: "48", rails_id: "16", name: "Computing" },
     { csharp_id: "47", rails_id: "15", name: "Communication and media studies" },
     { csharp_id: "5", rails_id: "14", name: "Classics" },
     { csharp_id: "4", rails_id: "13", name: "Citizenship" },
     { csharp_id: "3", rails_id: "12", name: "Chemistry" },
     { csharp_id: "2", rails_id: "11", name: "Business studies" },
     { csharp_id: "1", rails_id: "10", name: "Biology" },
     { csharp_id: "56", rails_id: "9", name: "Science" },
     { csharp_id: "0", rails_id: "8", name: "Art and design" },
     { csharp_id: "38", rails_id: "7", name: "Primary with science" },
     { csharp_id: "37", rails_id: "6", name: "Primary with physical education" },
     { csharp_id: "36", rails_id: "5", name: "Primary with modern languages" },
     { csharp_id: "35", rails_id: "4", name: "Primary with mathematics" },
     { csharp_id: "55", rails_id: "3", name: "Primary with geography and history" },
     { csharp_id: "32", rails_id: "2", name: "Primary with English" },
     { csharp_id: "31", rails_id: "1", name: "Primary" }]
  end
end
