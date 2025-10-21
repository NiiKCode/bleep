// app/javascript/controllers/delete_modal_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="delete-modal"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.modalEl = document.getElementById("confirmDeleteModal")
    if (!this.modalEl) return

    // Listen for Bootstrap's show event
    this.modalEl.addEventListener("show.bs.modal", (event) => {
      const button = event.relatedTarget
      const deleteUrl = button?.dataset.deleteUrl
      if (deleteUrl && this.hasFormTarget) {
        this.formTarget.action = deleteUrl
      }
    })
  }
}
