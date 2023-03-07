class Task < ActiveRecord::Base
    belongs_to :user
    enum status: { CREATED: 0, ONGOING: 1, COMPLETED: 2, CANCELLED: 3 }
end