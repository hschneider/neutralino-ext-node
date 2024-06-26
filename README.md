<p align="center">
<img src="https://marketmix.com/git-assets/neutralino-ext-node/neutralino-nodejs-header.svg" width="400px">
</p>


# neutralino-ext-node

**A NodeJS Extension for Neutralino >= 5.0.0**

This extension adds a NodeJS backend to Neutralino with the following features:
- Embedded NodeJS with all its dependencies for macOS, Linux and Windows Apps.
- Requires only a few lines of code on both ends.
- Read all events from the Neutralino app in your NodeJS code.
- Run NodeJS functions from Neutralino.
- Run Neutralino functions from NodeJS.
- All communication between Neutralino and NodeJS runs asynchronously.
- All events are queued, so none will be missed during processing.
- Track the data flow between Neutralino and NodeJS in realtime.
- Use Node's integrated debugger.
- Works in Window- and headless Cloud-Mode.
- Terminates the NodeJS Runtime when the Neutralino app quits.

### What this extension is not

This extension does not make NodeJS transparently available in your NeutralinoJS App. You just call particular functions on a NodeJS Backend and get back the result.



![Neutralino NodeJS Extension](https://marketmix.com/git-assets/neutralino-ext-node/nodejs-neutralino-extension.gif)

## Run the demo
The demo opens a Neutralino app. Clicking on the blue link sends a Ping to NodeJS, which replies with Pong. This illustrates the data-flow in both directions. 

Before running the demo, you need to install the **embedded NodeJS Runtime**. See chapter **"Integrate into your own Project"** below. 

You can also use an existing NodeJS installation. In that case, you need to adapt this part of **neutralino.config.json** as follows:

```json
"extensions": [
    {
      "id": "extNode",
      "commandDarwin": "node --inspect ${NL_PATH}/extensions/node/main.js",
      "commandLinux": "node --inspect ${NL_PATH}/extensions/node/main.js",
      "commandWindows": "node --inspect ${NL_PATH}/extensions/node/main.js"
    }
  ],
```

After this install the WebSocket module:

```bash
sudo npm install ws
```

When including the extension in your own project, make sure that **neutralino.config.json** contains this whitelist:

```json
  "nativeAllowList": [
    "app.*",
    "os.*",
    "window.*",
    "events.*",
    "extensions.*",
    "debug.log"
  ],
```

After this, run these commands in the ext-node folder:
```commandline
neu update
neu run
```

## ./extensions/node/main.js explained

```JS
const NeutralinoExtension = require('./neutralino-extension');
const DEBUG = true;     // Print incoming event messages to the console

function ping(d) {
    //
    // Send some data to the Neutralino app

    ext.sendMessage('pingResult', `NodeJS says PONG, in reply to "${d}"`);
}

function processAppEvent(d) {
    // Handle Neutralino app events.
    // :param data: data package as JSON dict.
    // :return: ---

    if(ext.isEvent(d, 'runNode')) {
        if(d.data.function === 'ping') {
            ping(d.data.parameter);
        }
    }
}

// Activate Extension
//
const ext = new NeutralinoExtension(DEBUG);
ext.run(processAppEvent);
```

The extension is activated with the last 2 lines. 
**processAppEvent** is a callback function, which is triggered with each event coming from the Neutralino app.

In the callback function, you can process the incoming events by their name. In this case we react to the **"runNode"** event.
**data.function** holds the requested NodeJS function and **data.parameter** its data payload as string or JSON.

if the requested function is named ping, we call the ping-function which sends a message back to Neutralino. 

**sendMessage()** requires the following parameters:

- An event name, here "pingResult"
- The data package to send, which can be of type string or JSON.

The **DEBUG** variable tells the NeutralinoExtension to report each event to the console. Incoming events, incoming function calls and outgoing messages are printed in different colors.
This makes debugging easier, since you can track the data flow between Neutralino and NodeJS:

![Debug NodeJS](https://marketmix.com/git-assets/neutralino-ext-node/nodejs-console.jpg)

## ./resources/js/main.js explained

```JS

async function onPingResult(e) {
...
}

// Init Neutralino
//
Neutralino.init();
...
Neutralino.events.on("pingResult", onPingResult);
...
// Init NodeJS Extension
const NODE = new NodeExtension(true)
```

The last line initializes the JavaScript part of the NodeJS extension. It's important to place this after Neutralino.init() and after all event handlers have been installed. Put it in the last line of your code and you are good to go. The const **NODE** is accessible globally.

The **NodeExtension class** takes only 1 argument which instructs it to run in debug mode (here true). In this mode, all data from the NodeJS extension is printed to the dev-console:

![Debug Meutralino](https://marketmix.com/git-assets/neutralino-ext-node/nodejs-neutralino-console.jpg)

The **pingResult event handler** listens to messages with the same name, sent by sendMessage() on Node's side. 

In **index.html**, you can see how to send data from Neutralino to NodeJS, which is dead simple:
```html
<a href="#" onclick="NODE.run('ping', 'Neutralino says PING!');">Send PING to Node</a><br>
```

**NODE.run()** takes 2 arguments:

- The NodeJS function to call, here "ping"
- The data package to submit, either as string or JSON.

Below this link, you see
```html
<a id="link-quit" href="#" onclick="NODE.stop();" style="display:none">Quit</a>
```
**NODE.stop()** is only required, when running Neutralino in cloud-mode. This will unload the NODE runtime gracefully.

## Integrate into your own project

Just follow these steps:

- Modify **neutralino.config.json**, like mentioned in **"Run the demo"**.
- Copy the **extensions** folder to your project.
- Adapt the JS code in **extensions/node/main.js** to your needs.
- Copy **resources/js/node-extension.js** to **resources/js**.
- Add `<script src="js/node-extension.js"></script>` to your **index.html**
- Add `const NODE = new NodeExtension(true)` to your **main.js**
- Add **NODE.run(function_name, data) to main.js** to run NodeJS functions from Neutralino.
- Add **event listeners to main.js**, to fetch result data from NodeJS.

### Embed NodeJS in your macOS or Linux App

The following scripts require the **[Git Commandline-Tools](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)** and **Python 3**. 

To embed NodeJS with all its dependencies, enter the following commands in the terminal:

```bash
cd extensions/node
./install.sh
./npm install ws
```

This creates a complete NodeJS environment under `extensions/node/_runtime/nodejs`. 

If you need to install further modules, use 

```bash
cd extensions/node
./npm install MODULE
```

**install.sh** and **npm** can be deleted before deployment.

### Embed NodeJS in your Windows App

The following scripts require the **[Git Commandline-Tools](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)** and **Python 3**. 

Open an admin command prompt end enter:

```bash
cd extensions\node
install.cmd
npm.cmd install ws
```

This creates a complete NodeJS environment under `extensions\node\_runtime\nodejs-win`. 

If you need to install further modules, use 

```bash
cd extensions\node
npm.cmd install MODULE
```

**install.cmd** and **npm.cmd** can be deleted before deployment.

### More about embedded NodeJS

Embedding is based on NodeEnv by Eugene Kalinin. Thanks to Eugene for this wonderful solution. You can read more about the NodeEnv here: [https://github.com/ekalinin/nodeenv](https://github.com/ekalinin/nodeenv)

## Classes overview

### neutralino-extension.js

| Method                           | Description                                                                                                                     |
|----------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| NeutralinoExtension(debug=false) | Extension class. debug: Print data flow to the terminal.                                                                        |
| debugLog(msg, tag="info")        | Write a message to the terminal. msg: Message, tag: The message type, "in" for incoming, "out" for outgoing, "info" for others. |
| isEvent(e, eventName)            | Checks the incoming event data package for a particular event.                                                                  |
| run(onReceiveMessage)            | Starts the sockethandler main loop. onReceiveMessage: Callback function for incoming messages.                                  |
| sendMessage(event, data=null)    | Send a message to Neutralino. event: Event-name, data: Data package as string or JSON.                                          |

### node-extension.js

| Method                    | Description                                                                                    |
|---------------------------|------------------------------------------------------------------------------------------------|
| NodeExtension(debug=false) | Extension class. debug: Print data flow to the dev-console.                                    |
| async run(f, p=null)      | Call a NodeJS function. f: Function-name, p: Parameter data package as string or JSON.       |
| async stop()              | Stop and quit the NodeJS extension and its parent app. Use this if Neutralino runs in Cloud-Mode. This is called automatically, when the browser tab is closed. |

## More about Neutralino

- [NeutralinoJS Home](https://neutralino.js.org) 

- [Neutralino Build Automation for macOS, Windows, Linux](https://github.com/hschneider/neutralino-build-scripts)

- [Neutralino related blog posts at marketmix.com](https://marketmix.com/de/tag/neutralinojs/)



<img src="https://marketmix.com/git-assets/star-me-2.svg">

