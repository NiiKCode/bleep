// app/javascript/controllers/index.js
import { application } from "./stimulus_application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)
