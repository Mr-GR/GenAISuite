import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        console.log('generic from controller connected', this.element)
    }
    reset() {
        this.element.reset()
    }
}