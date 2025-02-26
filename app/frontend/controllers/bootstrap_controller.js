import { Controller } from "@hotwired/stimulus"
import { Tooltip } from 'bootstrap';


export default class extends Controller {
  connect() {
    let tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    let tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new Tooltip(tooltipTriggerEl)
    })
  }
}