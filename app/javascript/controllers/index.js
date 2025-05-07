// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import Chartjs from '@stimulus-components/chartjs'
application.register('chartjs', Chartjs)

eagerLoadControllersFrom("controllers", application)
