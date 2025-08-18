import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["originalUrl", "token", "submit"]

  connect() {
    this.validate()
  }

  validate() {
    const urlFilled   = this.originalUrlTarget.value.trim() !== ""
    const tokenFilled = this.tokenTarget.value.trim() !== ""
    this.submitTarget.disabled = !(urlFilled && tokenFilled)
  }
}
