// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

document.addEventListener("DOMContentLoaded", () => {
  const confirmDeleteModal = document.getElementById("confirmDeleteModal");
  const deleteForm = document.getElementById("deleteForm");

  confirmDeleteModal.addEventListener("show.bs.modal", (event) => {
    const button = event.relatedTarget;
    const url = button.getAttribute("data-delete-url");
    deleteForm.setAttribute("action", url);
  });
});
