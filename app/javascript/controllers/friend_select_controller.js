import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "email",
    "results",
    "friendsList",
    "input",
    "section",
    "chevron"
  ]

  connect() {
    this.timeout = null
  }

  // ========================
  // LIVE SEARCH
  // ========================
  search() {
    clearTimeout(this.timeout)

    const query = this.emailTarget.value.trim()

    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    this.timeout = setTimeout(() => {
      fetch(`/users/search?q=${query}`)
        .then(res => res.json())
        .then(data => this.showResults(data))
    }, 300)
  }

  showResults(users) {
    this.resultsTarget.innerHTML = ""

    users.forEach(user => {
      const div = document.createElement("div")

      div.className = "p-3 border rounded-xl cursor-pointer hover:bg-gray-100"

      div.innerHTML = `
        <div class="font-semibold">${user.email}</div>
      `

      div.addEventListener("click", () => {
        this.addFriend(user)
      })

      this.resultsTarget.appendChild(div)
    })
  }

  // ========================
  // CREATE FRIEND (AJAX)
  // ========================
  async addFriend(user) {
    try {
      const response = await fetch("/friends", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
        },
        body: JSON.stringify({ email: user.email })
      })

      if (!response.ok) {
        const error = await response.json()
        alert(error.error)
        return
      }

      const data = await response.json()

      // Prevent duplicates in UI
      const existing = this.friendsListTarget.querySelector(
        `[data-friend-id='${data.id}']`
      )

      if (existing) {
        existing.click()
        return
      }

      this.insertFriendRow(data)

      this.emailTarget.value = ""
      this.resultsTarget.innerHTML = ""

    } catch (e) {
      console.error(e)
    }
  }

  insertFriendRow(data) {
    const row = document.createElement("div")

    row.className =
      "border rounded-xl p-4 cursor-pointer transition hover:bg-gray-50"

    row.setAttribute("data-friend-select-target", "row")
    row.setAttribute("data-action", "click->friend-select#toggle")
    row.dataset.friendId = data.id

    row.innerHTML = `
      <div class="font-semibold">${data.email}</div>
      <div class="text-sm text-gray-500">${data.initials}</div>
      <div data-friend-select-target="message"
           class="hidden text-sm mt-2 text-green-600 font-semibold">
        Partner selected
      </div>
    `

    this.friendsListTarget.prepend(row)

    row.click()
  }

  // ========================
  // SELECT / DESELECT
  // ========================
  toggle(event) {
    const row = event.currentTarget

    const friendId = row.dataset.friendId

    if (this.inputTarget.value === friendId) {
      this.clearSelection()
      return
    }

    this.clearSelection()

    row.classList.add("bg-green-100", "border-green-600")

    row.querySelector("[data-friend-select-target='message']")
       ?.classList.remove("hidden")

    this.inputTarget.value = friendId
  }

  clearSelection() {
    const rows = this.friendsListTarget.querySelectorAll("[data-friend-id]")

    rows.forEach(row => {
      row.classList.remove("bg-green-100", "border-green-600")
      row.querySelector("[data-friend-select-target='message']")
         ?.classList.add("hidden")
    })

    this.inputTarget.value = ""
  }

  // ========================
  // COLLAPSE
  // ========================
  toggleSection() {
    const section = this.sectionTarget

    if (section.classList.contains("max-h-0")) {
      section.classList.remove("max-h-0", "opacity-0")
      section.classList.add("max-h-[1000px]", "opacity-100")
      this.chevronTarget.innerText = "–"
    } else {
      section.classList.remove("max-h-[1000px]", "opacity-100")
      section.classList.add("max-h-0", "opacity-0")
      this.chevronTarget.innerText = "+"
    }
  }
}
