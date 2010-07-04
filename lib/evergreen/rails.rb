require 'evergreen'

module Evergreen
  class << self
    def rails
      application(Rails.root)
    end
  end
end
