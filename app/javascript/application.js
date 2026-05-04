import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

// Delete modal logic (keep this)
document.addEventListener("turbo:load", () => {
  document.addEventListener("click", (event) => {
    const el = event.target.closest(".delete-link")
    if (!el) return

    const modalEl = document.getElementById("confirmDeleteModal")
    const deleteForm = document.getElementById("deleteForm")

    if (!modalEl || !deleteForm) return

    event.preventDefault()

    const url = el.dataset.deleteUrl
    if (!url) return

    deleteForm.setAttribute("action", url)

    const modal = window.bootstrap.Modal.getOrCreateInstance(modalEl)
    modal.show()
  })
})
