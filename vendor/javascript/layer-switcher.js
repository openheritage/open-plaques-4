export default class LayerSwitcher {
  onAdd(map) {
    this._map = map

    this._container = document.createElement('div')
    this._container.classList.add('mapboxgl-ctrl')

    var nav = document.createElement('nav')
    nav.classList.add('navbar')
    nav.classList.add('navbar-light')
    nav.classList.add('bg-light')
    this._container.appendChild(nav)

    var containerFluid = document.createElement('div')
    containerFluid.classList.add('container')
    nav.appendChild(containerFluid)

    var toggler = document.createElement('button')
    toggler.classList.add('navbar-toggler')
    toggler.classList.add('float-right')
    toggler.type = 'button'
    var toggle = document.createAttribute('data-bs-toggle')
    toggle.value = 'collapse'
    toggler.setAttributeNode(toggle)
    var target = document.createAttribute('data-bs-target')
    target.value = '#layer-switcher'
    toggler.setAttributeNode(target)
    var togglerIcon = document.createElement('span')
    togglerIcon.classList.add('navbar-toggler-icon')
    toggler.appendChild(togglerIcon)
    containerFluid.appendChild(toggler)

    var menuContainer = document.createElement('div')
    menuContainer.classList.add('collapse')
    menuContainer.classList.add('navbar-collapse')
    menuContainer.id = 'layer-switcher'
    containerFluid.appendChild(menuContainer)

    this._menu = document.createElement('ul')
    this._menu.className = 'navbar-nav'
    menuContainer.appendChild(this._menu)

    return this._container;
  }
  
  onRemove() {
    console.log('remove layer switcher')
    this._container.parentNode.removeChild(this._container)
    this._map = undefined
  }

  check(layer_or_toggler) {
    const layer = layer_or_toggler.replace('_layer_toggler', '')
    this._map.setLayoutProperty(layer, 'visibility', 'visible')
    const toggler = this._toggler(layer)
    if (toggler !== undefined) {
      toggler.classList.add('active')
    }
  }

  check_all() {
    const names = this.item_names()
    console.log('menu items', names)
    for (var name of names) {
      this.check(name)
    }
  }

  item_names() {
    var names = []
    for (var nav_item of this._menu.children) {
      names.push(nav_item.firstChild.id)
    }
    return names
  }

  menuItem(id) {
    var map = this._map
    var menu = this._menu
    for (var name of this.item_names()) {
      if (name === `${id}_layer_toggler`) {
        console.log(`${id} already exists`)
        return
      }
    }
    console.log(`add ${id} to layer switcher`)
    var navItem = document.createElement('li')
    navItem.classList.add('nav-item')
    var link = document.createElement('a')
    link.id = `${id}_layer_toggler`
    link.href = '#'
    link.textContent = id.replaceAll('-', ' ').replaceAll('_', ' ')
    link.classList.add('nav-link')
    link.classList.add('active')
    link.onclick = function (e) {
      e.preventDefault()
      e.stopPropagation()
      const layer_switcher = map._controls.find(ele => ele instanceof LayerSwitcher)
      layer_switcher.toggle(e.target.id)
    }
    navItem.appendChild(link)
    menu.appendChild(navItem)
    const visibility = this._map.getLayoutProperty(id, 'visibility')
    if (visibility === undefined || visibility === 'visible') {
      this.check(id)
    } else {
      this.uncheck(id)
    }
  }

  remove(layer_or_toggler) {
    const layer = layer_or_toggler.replace('_layer_toggler', '')
    const menu = this._menu
    for (var nav_item of menu.children) {
      if (nav_item.firstChild.id === `${layer}_layer_toggler`) {
        console.log(`removing ${layer} from layer switcher`)
        menu.removeChild(nav_item)
        break
      }
    }
  }

  remove_all() {
    const names = this.item_names()
    console.log('menu items', names)
    for (var name of names) {
      this.remove(name)
    }
  }

  toggle(layer_or_toggler) {
    const id = layer_or_toggler.replace('_layer_toggler', '')
    console.log(`toggle('${id}')`)
    const visibility = this._map.getLayoutProperty(id, 'visibility')
    if (visibility === undefined || visibility === 'visible') {
      this.uncheck(id)
    } else {
      this.check(id)
    }
  }

  uncheck(layer_or_toggler) {
    const id = layer_or_toggler.replace('_layer_toggler', '')
    this._map.setLayoutProperty(id, 'visibility', 'none')
    const toggler = this._toggler(id)
    if (toggler !== undefined) {
      toggler.classList.remove('active')
    }
  }

  uncheck_all() {
    const names = this.item_names()
    console.log('menu items', names)
    for (var name of names) {
      this.uncheck(name)
    }
    for (var layer of this._map.getStyle().layers) {
      if (layer.id.includes('critical_drainage_area') || layer.id.includes('local_authorities') || layer.id.includes('project_canals')) {
        this.uncheck(layer.id)
      }
    }
  }

  _toggler(layer_or_toggler) {
    var layer = layer_or_toggler.replace('_layer_toggler', '')
    for (var nav_item of this._menu.children) {
      if (nav_item.firstChild.id === `${layer}_layer_toggler`) {
        return nav_item.firstChild
      }
    }
    return undefined
  }
}
