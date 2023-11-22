import "BlindNinjaCore"
import "GenericLevelComponents"
import "ComposableLevel"

transaction(levelName: String) {
  prepare(signer: AuthAccount) {
    // Ensure we have a level collection to store these levels in on this account
    if signer.borrow<&BlindNinjaCore.LevelCollection>(from: /storage/levelCollection) == nil {
      let newLevelCollection <- BlindNinjaCore.createLevelCollection()
      signer.save(<-newLevelCollection, to: /storage/levelCollection)
      signer.link<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection, target: /storage/levelCollection)
    }

    let levelCollection: &BlindNinjaCore.LevelCollection = signer.borrow<&BlindNinjaCore.LevelCollection>(from: /storage/levelCollection)!
    
    // Final set of game objects are provided via this object.
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    
    // Create the ninja for the map
    let ninja = GenericLevelComponents.GenericNinja(id: 1)
    ninja.setReferencePoint([4,4])
    gameObjects[Int(ninja.id)] = ninja

    // Create the flag to place on the map
    let flag = GenericLevelComponents.Flag(id: 2)
    flag.setReferencePoint([10,5])
    gameObjects[Int(flag.id)] = flag

    // Create 3 wall objects right in front of
    // where the flag was placed
    var y = 3
    var wallID = 3
    while (wallID <= 5) {
      let wall = GenericLevelComponents.Wall(id: UInt64(wallID))
      wall.setReferencePoint([5,y])
      gameObjects[Int(wall.id)] = wall
      y = y + 1
      wallID = wallID + 1
    }

    y = 0
    while (wallID <= 15) {
      let wall = GenericLevelComponents.Wall(id: UInt64(wallID))
      wall.setReferencePoint([3,y])
      gameObjects[Int(wall.id)] = wall
      y = y + 1
      wallID = wallID + 1
    }

    // Create a move mechanic which makes it so that
    // the ninja moves according to the inputted sequence
    // for the level.
    let moveMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.NinjaMovement(ninjaID: 1)

    // Create a wall mechanic, that makes it so that if a ninja
    // runs into the wall, their movement is reverted back.
    // This is to meant to run after the move mechanic.
    let wallMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.WallMechanic(ninjaID: 1, wallType: Type<GenericLevelComponents.Wall>())

    // Center the camera around the ninja at the end of each tick.
    let centeredCameraMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.CenteredCamera(centeredObjectID: 1)

    // Create a win condition for the level, where the ninja
    // must touch the flag to win.
    let winCondition = GenericLevelComponents.NinjaTouchGoal(
      ninjaID: ninja.id,
      goalID: flag.id
    )

    // Create the level, combining all of the above elments.
    let level <- ComposableLevel.createLevel(
      name: levelName,
      map: GenericLevelComponents.Map(
        anchorX: 0,
        anchorY: 0,
        viewWidth: 9,
        viewHeight: 9
      ),
      gameObjects: gameObjects,
      mechanics: [
        moveMechanic,
        wallMechanic,
        centeredCameraMechanic
      ],
      visuals: [],
      winConditions: [
        winCondition
      ],
    )

    // If this level already exist, delete it and add it to the collection
    // TODO: On live networks or in the future, we should make deleting a
    // separate step from updating/adding a new level, to make sure no one
    // accidentally deletes their level that is live and possibly in use
    let levelNames = levelCollection.getLevelNames()
    if levelNames.length > 0 {
      for name in levelNames {
        if (levelName == name) {
          let oldLevel <- levelCollection.removeLevel(levelName)
          destroy oldLevel
        }
      }
    }
    levelCollection.addLevel(<-level)
  }
}
