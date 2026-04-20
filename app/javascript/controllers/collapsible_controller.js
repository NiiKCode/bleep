import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["section", "chevron"]

  toggle() {
    this.sectionTarget.classList.toggle("hidden")
    this.chevronTarget.classList.toggle("rotate-180")
  }
}
