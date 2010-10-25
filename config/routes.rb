Rails.application.routes.draw do
  mount Evergreen.rails, :at => '/evergreen'
end
