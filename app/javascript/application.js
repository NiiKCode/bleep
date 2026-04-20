import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

document.addEventListener("click", (event) => {
  const el = event.target.closest(".delete-link")
  if (!el) return

  const modalEl = document.getElementById("confirmDeleteModal")
  const deleteForm = document.getElementById("deleteForm")

  if (!modalEl || !deleteForm) return

  event.preventDefault()

  const url = el.dataset.deleteUrl
  if (!url) {
    console.warn("Missing data-delete-url on", el)
    return
  }

  deleteForm.setAttribute("action", url)

  const modal = window.bootstrap.Modal.getOrCreateInstance(modalEl)
  modal.show()
})
