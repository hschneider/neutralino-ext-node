// NodeExtension
//
// Run NodeExtension functions by sending dispatched event messages.
//
// (c)2023 Harald Schneider - marketmix.com

class NodeExtension {
    constructor(debug=false) {
        this.version = '1.0.1';
        this.debug = debug;

        if(NL_MODE !== 'window') {
            window.addEventListener('beforeunload', function (e) {
                e.preventDefault();
                e.returnValue = '';
                NODE.stop();
                return '';
            });
        }
    }
    async run(f, p=null) {
        //
        // Call a NodeExtension function.

        let ext = 'extNode';
        let event = 'runNode';

        let data = {
            function: f,
            parameter: p
        }

        if(this.debug) {
            console.log(`EXT_NODE: Calling ${ext}.${event} : ` + JSON.stringify(data));
        }

        await Neutralino.extensions.dispatch(ext, event, data);
    }

    async stop() {
        //
        // Stop and quit the Node-extension and its parent app.
        // Use this if Neutralino runs in Cloud-Mode.

        let ext = 'extNode';
        let event = 'appClose';

        if(this.debug) {
            console.log(`EXT_NODE: Calling ${ext}.${event}`);
        }
        await Neutralino.extensions.dispatch(ext, event, "");
        await Neutralino.app.exit();
    }
}