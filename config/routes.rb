Rails.application.routes.draw do
  mount Evergreen.build_application, :at => '/evergreen'
end
