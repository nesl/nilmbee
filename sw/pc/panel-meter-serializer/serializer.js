// Panel meter packet serializer
// Allow multiple client to access the meter

var PORT = 4660;
var UPLINK_ADDRESS = '172.17.5.177';
var UPLINK_PORT = 4660;

var net = require('net');

var messages = [];

var uplink = (function(){
    var upconn;
    var state = 'IDLE';
    
    function connect() {
        if (state == 'IDLE') {
            upconn = net.connect(UPLINK_PORT, UPLINK_ADDRESS, function(){
                state = 'CONNECTED';
                console.log('Uplink connected.');
            });
            upconn.setNoDelay();
            upconn.setTimeout(60000, function(){
                upconn.end();
                state = 'IDLE';
            });
            upconn.on('close', function(){
                state = 'IDLE';
                console.log('Uplink closed.');
            });
            upconn.on('data', function(data){
                if (messages.length) {
                    messages[0].conn.write(data);
                    //console.log('Received data passed to ' + messages[0].conn.remoteAddress);
                    messages.shift();
                    if (state == 'WAITING') state = 'CONNECTED';
                    if (messages.length) setTimeout(sendnext, 100);
                }
            });
            upconn.on('error', function(e){
                // Nothing
            });

            state = 'CONNECTING';
            console.log('Uplink connecting....');
        }
    }
    
    function sendnext() {
        if (messages.length) {
            if (state == 'CONNECTED') {
                upconn.write(messages[0].data);
                //console.log('Sent data for ' + messages[0].conn.remoteAddress);
                state = 'WAITING';
            } else if (state == 'IDLE') {
                connect();
                setTimeout(sendnext, 500);
            } else if (state == 'CONNECTING') {
                setTimeout(sendnext, 500);
            }
        }
    }
    
    return {
        connect: connect, 
        sendnext: sendnext
    };
})();

var server = net.createServer(function(conn){

    conn.setNoDelay();
    conn.on('connect', function(){
        console.log('Client ' + conn.remoteAddress + ' connected.');
        uplink.connect();
    });
    
    conn.on('data', function(data) {
        messages.push({
            'conn': conn, 
            'data': data
        });
        uplink.sendnext();
    });

})

server.on('error', function (e) {
    console.log('Server error: ' + e.code);
    if (e.code == 'EADDRINUSE') {
        setTimeout(function () {
            server.close();
            server.listen(PORT);
        }, 1000);
    }
});

server.listen(PORT);

