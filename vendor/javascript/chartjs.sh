curl https://cdn.jsdelivr.net/npm/chart.js/+esm -o vendor/javascript/chart.js.js
curl https://cdn.jsdelivr.net/npm/@kurkle/color/+esm -o vendor/javascript/kurklecolor.js
# Manually change the import statement in the chart.js.js file to:
# import {Color as t} from "kurklecolor"
# curl https://ga.jspm.io/npm:chart.js@4.4.9/_/Cmj3nJD8.js -o vendor/javascript/Cmj3nJD8.js 