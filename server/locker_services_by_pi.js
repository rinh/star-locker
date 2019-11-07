/**
 * https://maker.pro/raspberry-pi/tutorial/how-to-control-a-raspberry-pi-gpio-pin-with-a-nodejs-web-server
 */
var Gpio = require('onoff').Gpio;
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8765 })

const DEBUG = process.argv[2] == "debug"
if( DEBUG ) {
    console.info('debug mode. port 8765')
}

function noop() {}
function heartbeat() {
    this.isAlive = true; 
}

wss.on('connection', function connection (ws, req) {
    ws.req = req;
    ws.isAlive = true;
    ws.on('pong', heartbeat);
    console.log('connected');

    ws.on('message', function incoming (message) {
        if( DEBUG ) {
            console.info( 'receive: ' , message )
        } else {
            var fn = DISPATCH_EVENTS[message];
            if( fn ) { fn( message , ws ) };
        }
    })
});

wss.on('close', function close () {
    console.log('disconnected')
});

const interval = setInterval(function ping () {
    wss.clients.forEach(function each (ws) {
        if (ws.isAlive === false) {
            console.info( `ws terminate.` )
            return ws.terminate()
        }
        console.info(`${ws.req.connection.remoteAddress} ws.isAlive ${ws.isAlive}`)
        ws.isAlive = false 
        ws.ping(noop)
    })
}, 3000);

/****
 * 正文
 */

if( !DEBUG ) {
    var LOCKER1_PIN = new Gpio( 17 , 'out' );
    var LOCKER2_PIN = new Gpio( 18 , 'out' );
}

var DISPATCH_EVENTS = {
    "locker_1/on" : ( message , ws ) => {
        LOCKER1_PIN.writeSync(1);
        console.info( message , LOCKER1_PIN.readSync() );
    } ,

    "locker_1/off" : ( message , ws ) => {
        LOCKER1_PIN.writeSync(0);
        console.info( message , LOCKER1_PIN.readSync() );
    } ,

    "locker_2/on" : ( message , ws ) => {
        LOCKER2_PIN.writeSync(1);
        console.info( message , LOCKER2_PIN.readSync() );
    } ,

    "locker_2/off" : ( message , ws ) => {
        LOCKER2_PIN.writeSync(0);
        console.info( message , LOCKER2_PIN.readSync() );
    } , 

    "reset" : ( message , ws ) => {
        LOCKER1_PIN.writeSync(0);
        LOCKER2_PIN.writeSync(0);
    }
}

process.on('SIGINT', _ => {
    if( !DEBUG ) {
        LOCKER1_PIN.unexport();
        LOCKER2_PIN.unexport();
    }
});
