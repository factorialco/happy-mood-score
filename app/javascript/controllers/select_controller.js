import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "dropdown" ]

  toggle(event) {
    event.preventDefault();

    if (this.dropdownTarget.classList.value.includes("hidden")) {
      this.updateClasses('block', 'hidden');
    } else {
      this.updateClasses('hidden', 'block');
    }
  }

  updateClasses(toAdd, toRemove) {
    this.dropdownTarget.classList.remove(toRemove);
    this.dropdownTarget.classList.add(toAdd);
  }
}
