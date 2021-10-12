function generateTerrian(x_pos,y_pos) {
    var b = Qt.createQmlObject("import \"../Rigidbodies\"; TerrainRigidBody{position:  Qt.vector3d("+x_pos+",-50,"+y_pos+");}"
                               ,main_root,"terrian"+i)
    i++
    terrainTiles.push(b)
}

function generateHouse() {
    var b = Qt.createQmlObject("import \"../Rigidbodies\"; HouseRigidBody{position: Qt.vector3d(0.0,0.0,40.0);}"
                               ,main_root,"house"+i)
    i++
}

function generateBlocks() {
    for(var col=0;col<8;col++){
        for(var row=0;row<10;row++){
            var b = Qt.createQmlObject("import \"../Rigidbodies\"; BlockRigidBody{position: Qt.vector3d(0.0 +"+(row*8+0.5)+",1.0+"+col*8+",-60.0);}",view.scene,"cube"+i);
            i++
        }
    }
}


function machineGunFire() {
    var x = machinegun.gun.position.x
    var y = machinegun.gun.position.y
    var z = machinegun.gun.position.z
    var rot_x = machinegun.gun.eulerRotation.x
    var rot_y = machinegun.gun.eulerRotation.y
    var rot_z = machinegun.gun.eulerRotation.z
    var obj = Qt.createQmlObject("import \"../Rigidbodies\"; MissleRigidBody{position: Qt.vector3d("+x+","+y+","+z+"); \
                               eulerRotation: Qt.vector3d("+rot_x+","+rot_y+","+rot_z+");}"
                                 ,main_root,"shoot"+i);
    i++
}

function buildTrees() {
    for(var k = 0 ;k < 4;k++) {
        var x = Math.floor(Math.random() * 500) -250;
        var z = Math.floor(Math.random() * 500) -250;
        var y = 0.0
        var b = Qt.createQmlObject("import \"../Rigidbodies\"; TreeRigidBody{position: Qt.vector3d("+x+","+y+","+z+");}"
                                   ,main_root,"tree"+k)
    }
}

function generateTower() {
    var b = Qt.createQmlObject("import \"../Rigidbodies\"; TowerRigidBody{position:  Qt.vector3d(-500.0,100.0,450.0);}"
                               ,main_root,"tower"+i)
    i++
    var c = Qt.createQmlObject("import \"../Rigidbodies\"; TowerRigidBody{position:  Qt.vector3d(500.0,050.0,450.0);}"
                               ,main_root,"tower"+i)
    i++
}

function testRay() {
    //        var res  = view.rayPick(Qt.vector3d(0.0,100.0,0.0),Qt.vector3d(0.0,-10.0,0.0))
    //        console.log(res.objectHit)
}





function gravityBomb(modelObj) {
    //        var x = machinegun.gun.position.x
    //        var y = machinegun.gun.position.y
    //        var z = machinegun.gun.position.z
    //        var rot_x = machinegun.gun.gun.eulerRotation.x
    //        var rot_y = machinegun.gun.eulerRotation.y
    //        var rot_z = machinegun.gun.eulerRotation.z
    //        var obj = Qt.createQmlObject("import \"../Rigidbodies\"; StaticBombRigidBody{position: Qt.vector3d("+x+","+y+","+z+"); \
    //                                   eulerRotation: Qt.vector3d("+rot_x+","+rot_y+","+rot_z+");}"
    //                                     ,main_root,"shoot"+i);
    //        i++
}

function fire(modelObj) {
    var x = modelObj.scenePosition.x
    var y = modelObj.scenePosition.y
    var z = modelObj.scenePosition.z
    var rot_x = modelObj.eulerRotation.x
    var rot_y = modelObj.eulerRotation.y
    var rot_z = modelObj.eulerRotation.z
    var obj = Qt.createQmlObject("import \"../Rigidbodies\"; StaticBombRigidBody{position: Qt.vector3d("+x+","+y+","+z+"); \
                               eulerRotation: Qt.vector3d("+rot_x+","+rot_y+","+rot_z+");}"
                                 ,main_root,"shoot"+i);
    i++
}

function missle(modelObj) {
    var x = modelObj.scenePosition.x
    var y = modelObj.scenePosition.y
    var z = modelObj.scenePosition.z
    var rot_x = modelObj.eulerRotation.x*-1.0
    var rot_y = modelObj.eulerRotation.y
    var rot_z = modelObj.eulerRotation.z
    var obj = Qt.createQmlObject("import \"../Rigidbodies\"; MissleRigidBody{position: Qt.vector3d("+x+","+y+","+z+"); \
                               eulerRotation: Qt.vector3d("+rot_x+","+rot_y+","+rot_z+");}"
                                 ,main_root,"shoot"+i);
    i++
}


function setContoller(modelObj) {
    main_root.currentController = modelObj.controller
    modelObj.controller.enabled = true
    modelObj.controller.focus = true
}
