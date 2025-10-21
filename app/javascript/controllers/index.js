// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"
import DeleteModalController from "./delete_modal_controller.js"

const application = Application.start()

// Manually register controllers here (since Importmap doesn’t autoload)
application.register("delete-modal", DeleteModalController)
