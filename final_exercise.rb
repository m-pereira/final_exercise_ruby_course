require_relative 'student_class'
require_relative 'input_validator'

puts "Hello! This is an application for manage students"
puts "Please enter 'exit' if you want to go out. Otherwise, type anything else."

exit_input = gets.chomp

not_exit = false
while !not_exit do
	if exit_input == 'exit'
		not_exit = true

		puts "Goodbye!"
	else
		puts "Please chose one option:"		
		puts "1 for create a new student registration. 2 for update a student. 3 for delete one student."

		user_input = gets.chomp.to_i

		input_validation = InputValidator.new(user_input).call

		if user_input == 1 && input_validation
			print "Student name: "
			student_name = gets.chomp
			print "Student age: "
			student_age = gets.chomp
			print "Student email: "
			student_email = gets.chomp

			student = Student.new(name: student_name, age: student_age, email: student_email)

			if student.create
				puts "#{student.file_name} was created!"
			else
				puts "You got this errors: #{student.error_messages}."
			end

		elsif user_input == 2 && input_validation
			print "Please type the student id for edit: "
			input_id = gets.chomp

			student = Student.read(input_id)

			unless student
				puts "Any student with this id."
			else
				puts "Editind #{student.name}:"

				print "New name: "
				new_name = gets.chomp.capitalize
				print "New age: "
				new_age = gets.chomp.to_i
				print "New email: "
				new_email = gets.chomp

				student.name = new_name
				student.age = new_age
				student.email = new_email

				if student.update
					puts "File #{student.file_name} successfully updated."
				else
					puts "You got this erros: #{student.error_messages}." if student.error_messages
					puts "Update cannot be performed."
				end
			end

		elsif user_input == 3 && input_validation
			puts "You chosen to delete the student file."

			print "Please type the user id to destroy it: "
			user_input = gets.chomp

			if Student.destroy(user_input)
				puts "Student was successfully deleted."
			else
				puts "Invalid id."
			end
		end
		
		puts "Please enter 'exit' if you want to go out. Otherwise, type anything else."

		exit_input = gets.chomp
	end

end

