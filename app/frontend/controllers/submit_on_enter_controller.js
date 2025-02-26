import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  connect() {
    console.log('form', this.element.form)
    this.element.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("keydown", this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {

      event.preventDefault()


      if (this.element.value.trim() === "") {
        return
      }

    
      Turbo.navigator.submitForm(this.element.form)
    }
  }
}