
// main.js 1.0.2
//
// Neutralino NodeExtension.
//
// (c)2023 Harald Schneider - marketmix.com

const NeutralinoExtension = require('./neutralino-extension');
const DEBUG = true;     // Print incoming event messages to the console

function ping(d) {
    //
    // Send some data to the Neutralino app

    ext.sendMessage('pingResult', `Node says PONG, in reply to "${d}"`);
}

function processAppEvent(d) {
    // Handle Neutralino app events.
    // :param d: data package as JSON dict.
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
console.log('---')
console.log('NodeJS Version:', process.version);
console.log('NodeJS Path:', process.execPath);
console.log('---')
ext.run(processAppEvent);
