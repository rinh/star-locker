/**
 * https://maker.pro/raspberry-pi/tutorial/how-to-control-a-raspberry-pi-gpio-pin-with-a-nodejs-web-server
 */
var Gpio = require('onoff').Gpio;
const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8765 })

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
        var fn = DISPATCH_EVENTS[message];
        if( fn ) { fn( message , ws ) };
    })
});

wss.on('close', function close () {
    console.log('disconnected')
});

// const interval = setInterval(function ping () {
//     wss.clients.forEach(function each (ws) {
//         if (ws.isAlive === false) {
//             console.info( `ws terminate.` )
//             return ws.terminate()
//         }
//         console.info(`${ws.req.connection.remoteAddress} ws.isAlive ${ws.isAlive}`)
//         ws.isAlive = false
//         ws.ping(noop)
//     })
// }, 3000);

/****
 * 正文
 */

var LOCKER_PIN = new Gpio( 17 , 'out' );

var DISPATCH_EVENTS = {
    "locker/on" : ( message , ws ) => {
        LOCKER_PIN.writeSync(1);
        console.info( LOCKER_PIN.readSync() );
    } ,

    "locker/off" : ( message , ws ) => {
        LOCKER_PIN.writeSync(0);
        console.info( LOCKER_PIN.readSync() );
    }
}

process.on('SIGINT', _ => {
    LOCKER_PIN.unexport();
});
