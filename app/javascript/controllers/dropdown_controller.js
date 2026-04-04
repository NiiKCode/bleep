import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "label", "input", "chevron"]

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  toggle(event) {
    event.stopPropagation()

    this.menuTarget.classList.toggle("hidden")
    this.menuTarget.classList.toggle("opacity-0")
    this.menuTarget.classList.toggle("scale-95")

    this.chevronTarget.classList.toggle("rotate-180")
  }

  select(event) {
    const value = event.currentTarget.dataset.value
    const text = event.currentTarget.textContent.trim()

    this.labelTarget.textContent = text
    this.inputTarget.value = value

    this.close()

    this.element.closest("form").requestSubmit()
  }

  close() {
    this.menuTarget.classList.add("hidden", "opacity-0", "scale-95")
    this.chevronTarget.classList.remove("rotate-180")
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}
