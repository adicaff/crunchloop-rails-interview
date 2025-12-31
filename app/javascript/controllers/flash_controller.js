import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 3000)
  }

  dismiss() {
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateX(100%)'
    this.element.style.transition = 'opacity 0.5s, transform 0.5s'
    
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}
