require 'csv'
require 'securerandom'

class Student
  attr_accessor :id, :name, :age, :email
  attr_reader :file_name
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def initialize(id: SecureRandom.hex, name:, age:, email:)
    @id = id
    @name = name.capitalize
    @age = age.to_i
    @email = email
    @file_name = "#{id}_file.csv"
  end

  def valid?
    validate
    @errors.empty?
  end

  def error_messages
    @errors.map do |field, message|
      "#{field} #{message}"
    end
  end

  def save
    return false unless self.valid?
          
    CSV.open("data/#{id}_file.csv", "w") do |csv|
      csv << [id, name, age, email]
    end

    true
  end

  def create
    self.valid?  #It's neccessary because otherwise it won't has a @errors variable

    unless File.exist?(file_name)
      true if save
    else
      false
    end
  end

  def self.read(id)
    file = Student.file_name(id)

    if File.exist?(file)
      File.open(file, "r") do |file|
        parsed_person = CSV.parse(file.read)[0]

        #This is just creating a new instance variable to be read.
        return Student.new(id: id, name: parsed_person[1], age: parsed_person[2], email: parsed_person[3])
      end
    else
      false
    end
  end

  def update
    file = Student.file_name(@id)

    if File.exist?(file)
      save
    else
      false
    end
  end

  def self.destroy(id)
    file = Student.file_name(id)

    if File.exist?(file)
      File.delete(file)
      true
    else
      false
    end
  end

  private

  def validate
    @errors = {}

    validate_presence(name, :name) 
    validate_integer(age, :age)
    validate_email(email, :email)
  end

  def validate_presence(value, name)
    return unless (value.nil? || value.length < 3)
    
    @errors[name] = "is too short or nil."
  end

  def validate_integer(value, name)
    return unless (value.nil? || value <= 0)
    
    @errors[name] = "is an invalid number."
  end

  def validate_email(value, name)
    @email_valid = begin
      if value[VALID_EMAIL_REGEX]
        true
      else
        false
      end
    end

    return unless (value.nil? || !@email_valid)

    @errors[name] = "is an invalid email."
  end

  def self.file_name(id)
    "data/#{id}_file.csv"
  end
end
