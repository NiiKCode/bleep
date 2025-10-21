// app/javascript/application.js
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap" // loads and attaches bootstrap to window

document.addEventListener("DOMContentLoaded", () => {
  const modalEl = document.getElementById("confirmDeleteModal");
  const deleteForm = document.getElementById("deleteForm");

  if (!modalEl || !deleteForm) return;

  document.querySelectorAll(".delete-link").forEach((el) => {
    el.addEventListener("click", (event) => {
      event.preventDefault();

      const url = el.dataset.deleteUrl;
      if (!url) {
        console.warn("Missing data-delete-url on", el);
        return;
      }

      deleteForm.setAttribute("action", url);

      // ✅ Use global bootstrap reference (works with Importmap)
      const modal = window.bootstrap.Modal.getOrCreateInstance(modalEl);
      modal.show();
    });
  });
});
