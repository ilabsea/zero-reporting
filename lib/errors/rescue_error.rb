module Errors
  module RescueError
    def self.included(base)
      base.rescue_from Errors::UnprocessableEntity do |e|
        render text: e.message, status: :unprocessable_entity
      end
    end
  end
end
