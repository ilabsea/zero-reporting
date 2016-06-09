module Errors
  module RescueError
    def self.included(base)
      base.rescue_from Errors::UnprocessableEntity do |e|
        render text: e.message, status: :unprocessable_entity
      end

      base.rescue_from Errors::RecordNotFoundException do |e|
        render text: e.message, status: :internal_server_error
      end
    end
  end
end
