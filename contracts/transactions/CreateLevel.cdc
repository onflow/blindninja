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
    
    // Create the ninja for the map
    let ninja = GenericLevelComponents.GenericNinja(id: 1)
    ninja.setReferencePoint([5,5])

    // Create the flag to place on the map
    let flag = GenericLevelComponents.Flag(id: 2)
    flag.setReferencePoint([8,5])

    // Add these objects to the master list of game objects
    // for creating the new level.
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    gameObjects[Int(ninja.id)] = ninja
    gameObjects[Int(flag.id)] = flag

    // Create a move mechanic which makes it so that
    // the ninja moves according to the inputted sequence
    // for the level.
    let moveMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.NinjaMovement(ninjaID: 1)

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
        viewWidth: 20,
        viewHeight: 20
      ),
      gameObjects: gameObjects,
      mechanics: [
        moveMechanic
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
      let oldLevel <- levelCollection.removeLevel(levelName)
      destroy oldLevel
    }
    levelCollection.addLevel(<-level)
  }
}
