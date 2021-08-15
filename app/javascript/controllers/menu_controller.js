import { Controller } from "stimulus";

export default class extends Controller {
  static classes = ["show", "hide"];
  static targets = [ "mobile" ]

  connect() {
    this.mobileTarget.classList.add(this.hideClass);
  }

  toggle() {
    if (this.mobileTarget.classList.value === "hidden") {
      this.mobileTarget.classList.add(this.showClass);
      this.mobileTarget.classList.remove(this.hideClass);
    } else {
      this.mobileTarget.classList.remove(this.showClass);
      this.mobileTarget.classList.add(this.hideClass);
    }
  }
}
