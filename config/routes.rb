Rails.application.routes.draw do
  mount Evergreen.application(Rails.root), :at => '/evergreen'
end
