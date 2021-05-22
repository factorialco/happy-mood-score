import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "select" ];

  connect() {
    this.updateFrequency(document.getElementById('company_frequency').value);
  }

  update(event) {
    this.updateFrequency(event.target.value);
  }

  updateFrequency(newFrequency) {
    if (newFrequency === "daily") {
      this.updateClasses('hidden', 'block');
    } else {
      this.updateClasses('block', 'hidden');
    }
  }

  updateClasses(toAdd, toRemove) {
    this.selectTarget.classList.remove(toRemove);
    this.selectTarget.classList.add(toAdd);
  }
}
