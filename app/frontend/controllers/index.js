// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)
import removals_controller from "./removals_controller"
application.register("removals", removals_controller)

import generic_form_controller from "./generic_form_controller"
application.register("generic-form", generic_form_controller)

import BootstrapController from "./bootstrap_controller"
application.register("bootstrap", BootstrapController)