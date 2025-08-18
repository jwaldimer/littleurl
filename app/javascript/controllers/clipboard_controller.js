import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }

  async copy(event) {
    const btn = event.currentTarget
    if (!btn) return

    let text = this.textValue
    const original = btn.textContent
    try {
      await navigator.clipboard.writeText(text)
      btn.textContent = "Copied!"
    } catch {
      const ta = document.createElement("textarea")
      ta.value = text; ta.setAttribute("readonly", "")
      ta.style.position = "absolute"; ta.style.left = "-9999px"
      document.body.appendChild(ta); ta.select()
      document.execCommand("copy")
      document.body.removeChild(ta)
      btn.textContent = "Copied!"
    } finally {
      setTimeout(() => (btn.textContent = original), 2500)
    }
  }
}
