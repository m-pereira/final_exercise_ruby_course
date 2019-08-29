class InputValidator
	attr_accessor :input

	def initialize(input)
		@input = input
	end

	def call
		unless input.class == Integer
			return 'Input is not valid.'
		end

		if (1..4).include?(input)
			true
		else
			'Input is an invalid number.'
		end
	end
end