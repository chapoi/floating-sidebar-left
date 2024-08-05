import Component from "@glimmer/component";
import { action } from "@ember/object";
import { run } from "@ember/runloop";
import { service } from "@ember/service";

export default class CloseOnClick extends Component {
  @service router;

  handleClickOutside = (event) => {
    let floatingSidebar = document.getElementById("d-sidebar");
    let toggleButton = document.querySelector(".header-sidebar-toggle");
    let clickedElement = event.target;
    if (
      floatingSidebar &&
      !floatingSidebar.contains(clickedElement) &&
      !toggleButton.contains(clickedElement)
    ) {
      run(() => {
        Discourse.lookup("controller:application").toggleSidebar();
      });
    }
  };

  constructor() {
    super(...arguments);
    this.router.on("routeDidChange", this.handleRouteChange);
  }

  @action
  handleRouteChange() {
    if (document.getElementById("d-sidebar")) {
      run(() => {
        Discourse.lookup("controller:application").toggleSidebar();
      });
    }
  }

  @action
  sidebarVisible() {
    if (document.getElementById("d-sidebar")) {
      this.setupClickOutsideListener();
    }
  }

  @action
  setupClickOutsideListener() {
    document.addEventListener("click", this.handleClickOutside);
  }

  @action
  removeClickOutsideListener() {
    document.removeEventListener("click", this.handleClickOutside);
  }

  willDestroyElement() {
    super.willDestroyElement(...arguments);
    this.removeClickOutsideListener();
  }
}
