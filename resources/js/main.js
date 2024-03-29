
function onWindowClose() {
    Neutralino.app.exit();
}

async function onPingResult(e) {
    console.log("DBG RECEIVED: " + e.detail );

    let msg = document.getElementById("msg");
    msg.innerHTML += e.detail + '<br>';
}

function test() {
    let msg = document.getElementById("msg");
    msg.innerHTML += "Test from Xojo ...." + '<br>';
}

// Start a long-running task.
//
document.getElementById('link-long-run')
    .addEventListener('click', () => {
        NODE.run('longRun');
    });

// Init Neutralino
//
Neutralino.init();
Neutralino.events.on("windowClose", onWindowClose);
Neutralino.events.on("pingResult", onPingResult);

// Set title
//
(async () => {
    await Neutralino.window.setTitle(`Neutralino NodeExtension ${NL_APPVERSION}`);
    await Neutralino.window.show();
})();

(async () => {
    await Neutralino.os.spawnProcess(`kill {pid}`);
})();

// Init Node Extension
const NODE = new NodeExtension(true)

