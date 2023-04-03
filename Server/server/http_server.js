const wsapi = require('../Modules/WebSocketApi.js');
const molly = require('molly-js');
const path = require('path');

molly.createHTTPServer({
    controller: path.join(__dirname,'../','controller'),
    viewer: path.join(__dirname,'../','viewer'),
    port: 3000, host: '127.0.0.1', thread: 1,
},(server)=>{ wsapi(server) })