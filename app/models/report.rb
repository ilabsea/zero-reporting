class Report < ActiveRecord::Base
  belongs_to :user

  STATUS_LISTENED = 1
  STATUS_NEW      = 0

  STATUSES = [["Listened", STATUS_LISTENED], ["New", STATUS_NEW]]
end
