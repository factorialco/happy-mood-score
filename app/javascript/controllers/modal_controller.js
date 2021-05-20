import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "form" ];
  static classes = ["show", "hide"];

  connect() {
    this.element.classList.add(this.hideClass);
  }

  open() {
    this.updateClasses(this.showClass, this.hideClass);
  }

  close() {
    this.updateClasses(this.hideClass, this.showClass);
  }

  submit() {
    this.formTarget.requestSubmit();
    this.close();
  }

  ignore(event) {
    event.stopPropagation();
  }

  updateClasses(toAdd, toRemove) {
    this.element.classList.remove(toRemove);
    this.element.classList.add(toAdd);
  }
}
