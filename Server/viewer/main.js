window.godot = new Object();
window.godot.events = new Array();
window.state = new device.state();

window.state.observeField('server',(prev,act)=>{
    console.log(act,prev)
})