const { BrowserWindow } = require('electron')

class MainWindow extends BrowserWindow {
  constructor(file, isDev) {
    super({
      title: 'KC | Knowledge Catalog',
      width: isDev ? 850 : 550,
      height: 500,
      icon: `${__dirname}/assets/icons/icon.png`,
      // resizable: isDev ? true : false,
      show: false,
      // opacity: 0.95,
      webPreferences: {
        nodeIntegration: true,
      },
    })

    this.loadFile(file)

    if (isDev) {
      this.webContents.openDevTools()
    }
  }
}

module.exports = MainWindow
