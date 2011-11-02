Rails.application.routes.draw do
  mount Evergreen::Application, :at => '/evergreen'
end
