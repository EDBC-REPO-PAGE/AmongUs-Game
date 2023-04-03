const worker = require('worker_threads');
const path = require('path');
const fs = require('fs');

const dir = path.join(__dirname,'server');
fs.readdirSync(dir).map(x=>{
    const wrk = new worker.Worker(
        path.join(__dirname,'server',x),
        { SHARE_ENV: worker.SHARE_ENV }
    );
})