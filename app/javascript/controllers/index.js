// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import SubproductNestedFormController from "./subproduct_nested_form_controller"
application.register("subproduct-nested-form", SubproductNestedFormController)

import ProductNestedFormController from "./product_nested_form_controller"
application.register("product-nested-form", ProductNestedFormController)