# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrap via CDN (includes Popper)
# config/importmap.rb
pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"

# RailsAdmin assets
pin "rails_admin", to: "rails_admin/rails_admin.js"
pin "rails_admin.css", to: "rails_admin/rails_admin.css"
