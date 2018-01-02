class Transfer < ApplicationRecord
  belongs_to :call
  # this will be a minimal model used to track the transfers a caller has to go
  # through to get to their destination.
end
