module Errors
  class RecordNotFoundException < StandardError
    def initialize(message)
      super(message)
    end
  end
end
