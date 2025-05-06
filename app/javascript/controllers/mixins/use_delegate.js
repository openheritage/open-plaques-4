export const useDelegate = controller => {
  Object.assign(controller, {
    waitForController(name) {
      return new Promise(function(resolve) {
        controller.context.logDebugActivity(`looking for <div id='${name}'...>`)
        var elements = document.querySelectorAll(`[id='${name}']`)
        if (elements.length === 0) {
          throw new Error(`<... id="${name}"...> not found on this page`)
        }
        if (elements.length > 1) {
          throw new Error(`'${name}' is supposed to be a unique id!`)
        }
        var element = document.getElementById(name)

        if(element.controller) {
          controller.context.logDebugActivity(`found the controller at <div id='${name}'...>`)
          resolve(element.controller)
          return
        }
        
        controller.context.logDebugActivity(`controller isn't attached to <div id='${name}'...> yet. Waiting until it gets added.`)
        var observer = new MutationObserver(function(mutations) {
          mutations.forEach(function(mutation) {
            var nodes = Array.from(mutation.addedNodes)
            for(var node of nodes) {
              if(node.matches && node.matches('#controller')) {
                controller.context.logDebugActivity(`waited, then found the controller at <div id='${name}'...>`, node)
                observer.disconnect()
                var element = document.getElementById(name)
                resolve(element.controller)
                return
              }
            }
          })
        })
        observer.observe(document.documentElement, { childList: true, subtree: true })
      })
    }
  })
}
