const crypto = require('crypto-js');
const ws = require('ws');

//─────────────────────────────────────────────────────────────────────────────//

const regions = ['latam','usa','eur','global'];
const serverList = new Object();

//─────────────────────────────────────────────────────────────────────────────//

function create_new_game(name){
    serverList[name] = new Object();
    for( const region of regions )
        serverList[name][region] = new Array();
}

function get_client_id(data){
    const key = Object.keys(data.payload);
    const raw = key.map(x=>data.payload[x])
                   .join('|');
    return data.cli.send(JSON.stringify({
        data: crypto.SHA256(raw).toString(),
        type: 'client_id',
    }));
}

//─────────────────────────────────────────────────────────────────────────────//

function get_server_id(data){
    const {game,region,id,limit} = data.payload;
    if(!serverList[game]) create_new_game(game);

    for( server of serverList[game][region] ){
        if( server.client <= limit ){ 
            data.cli.send(JSON.stringify({
                data: server.id, type: 'server_id',
            }));server.client++; return 0;
        } else { server.close() }
    }

    const cli = data.cli;
    cli.client = 0; cli.id = id; 
    cli.game = game; cli.region = region;

    serverList[game][region].push(cli);
    data.cli.send(JSON.stringify({
        data: cli.id, type: 'server_id',
    }));return 0;
}

function set_server_id(data){
    const {game,region,id,client} = data.payload;
    if(!serverList[game]) create_new_game(game);

    const cli = data.cli;
    cli.client = client; cli.id = id;
    cli.game = game; cli.region = region;

    serverList[game][region].push(cli);
    data.cli.send(JSON.stringify({
        data: cli.id, type: 'server_id',
    }));return 0;
}

//─────────────────────────────────────────────────────────────────────────────//

function on_client_close(cli){
    if( !cli.id ) return 0;
    const { game, region, id } = cli;
    for( const i in serverList[game][region] ){
        if( serverList[game][region][i].id == id ) 
            serverList[game][region].splice(i,1);
    }
}

function on_client_message(cli,msg){
    try {
        const data = JSON.parse(msg); data.cli = cli; switch( data.type ){
            case 'get_server_id': get_server_id(data); break;
            case 'set_server_id': set_server_id(data); break;
            case 'get_client_id': get_client_id(data); break;
        }
    } catch(e) {
        cli.send(JSON.stringify({ message: e.message }))
    }
}

//─────────────────────────────────────────────────────────────────────────────//

module.exports = (server)=>{
    const wss = new ws.WebSocketServer({server});
    wss.on('connection',(client)=>{
        client.on('close',()=>on_client_close(client));
        client.on('message',(msg)=>on_client_message(client,msg));
    }); 
}