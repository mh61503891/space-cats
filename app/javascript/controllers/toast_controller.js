import { Controller } from "@hotwired/stimulus";
// import { Toast } from "bootstrap";

export default class extends Controller {
  connect() {
    const toast = new bootstrap.Toast(this.element);
    toast.show();
  }
}
