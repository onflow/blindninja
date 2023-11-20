import "BlindNinjaCore"
import "GenericLevelComponents"
import "ComposableLevel"

transaction(levelName: String) {
  prepare(signer: AuthAccount) {
    if signer.borrow<&BlindNinjaCore.LevelCollection>(from: /storage/levelCollection) == nil {
      let newLevelCollection <- BlindNinjaCore.createLevelCollection()
      signer.save(<-newLevelCollection, to: /storage/levelCollection)
      signer.link<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection, target: /storage/levelCollection)
    }

    let levelCollection: &BlindNinjaCore.LevelCollection = signer.borrow<&BlindNinjaCore.LevelCollection>(from: /storage/levelCollection)!
    let ninja = GenericLevelComponents.GenericNinja(id: 1)
    ninja.setReferencePoint([5,5])


    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    gameObjects[Int(ninja.id)] = ninja

    let moveMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.NinjaMovement(ninjaID: 1)

    let level <- ComposableLevel.createLevel(
      name: levelName,
      map: GenericLevelComponents.Map(),
      gameObjects: gameObjects,
      mechanics: [
        moveMechanic
      ],
      visuals: [],
      winConditions: [],
    )

    let levelNames = levelCollection.getLevelNames()
    if levelNames.length > 0 {
      let oldLevel <- levelCollection.removeLevel(levelName)
      destroy oldLevel
    }

    levelCollection.addLevel(<-level)
  }
}
