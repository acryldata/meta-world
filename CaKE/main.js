const path = require('path')
const { app, Menu, globalShortcut, clipboard, shell } = require('electron')
const Store = require('./Store')
const MainWindow = require('./MainWindow')
const AppTray = require('./AppTray')
const os = require('os')


// Set env
// process.env.NODE_ENV = 'development'
process.env.NODE_ENV = 'production'

const isDev = process.env.NODE_ENV !== 'production' ? true : false
const isMac = process.platform === 'darwin' ? true : false

let mainWindow
let tray

// Init store & defaults
const store = new Store({
  configName: 'user-settings',
  defaults: {
    settings: {
      hotkey: 'A',
    },
  },
})

function createMainWindow() {
  mainWindow = new MainWindow('./app/index.html', isDev)
}

app.on('ready', () => {
  createMainWindow()
  const ret = globalShortcut.register('CommandOrControl+shift+A', () => {
    const text = clipboard.readText();
    const username = os.userInfo()['username'];
    mainWindow.webContents.send("search", text, username)
    mainWindow.show()
  })

  if (!ret) {
    console.log('registration failed')
  }

  // Check whether a shortcut is registered.
  console.log(globalShortcut.isRegistered('CommandOrControl+shift+A'))

  mainWindow.webContents.on('dom-ready', () => {
    mainWindow.webContents.send('settings:get', store.get('settings'))
  })

  mainWindow.webContents.on('will-navigate', function (e, url) {
    e.preventDefault();
    shell.openExternal(url);
  });
  const mainMenu = Menu.buildFromTemplate(menu)
  Menu.setApplicationMenu(mainMenu)

  mainWindow.on('close', (e) => {
    if (!app.isQuitting) {
      e.preventDefault()
      mainWindow.hide()
    }

    return true
  })

  const icon = path.join(__dirname, 'assets', 'icons', 'tray_icon.png')

  // Create tray
  tray = new AppTray(icon, mainWindow)
})

const menu = [
  ...(isMac ? [{ role: 'appMenu' }] : []),
  {
    role: 'fileMenu',
  },
  {
    label: 'View',
    submenu: [
      {
        label: 'Toggle Navigation',
        click: () => mainWindow.webContents.send('nav:toggle'),
      },
    ],
  },
  ...(isDev
    ? [
        {
          label: 'Developer',
          submenu: [
            { role: 'reload' },
            { role: 'forcereload' },
            { type: 'separator' },
            { role: 'toggledevtools' },
          ],
        },
      ]
    : []),
]

app.on('window-all-closed', () => {
  if (!isMac) {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createMainWindow()
  }
})

app.allowRendererProcessReuse = true
