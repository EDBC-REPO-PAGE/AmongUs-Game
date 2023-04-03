    window.task = new Object();

    function getTaskInterval(size){
        const middle = Math.floor(Math.random()*size);
            if( middle >= size - 4 )
                return [ size - 5, size - 1 ];
                return [ middle, middle + 4 ];
    }

    function getRandomTasks(){

        const tasks = `
            data oxigen reactor asteroids
            electricity motor navigation 
            admin wiring shield trash
        `.match(/\w+/gi);

        const size = tasks.length;

        return tasks
        .sort(()=>Math.random()>=1/2?1:-1)
        .slice(...getTaskInterval(size));

    }