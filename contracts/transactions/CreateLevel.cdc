import "BlindNinjaCore"
import "SampleLevel"
import "ComposableLevel"

transaction(levelName: String) {
  prepare(signer: AuthAccount) {
    if signer.borrow<&BlindNinjaCore.LevelCollection>(from: /storage/levelCollection) == nil {
      let newLevelCollection <- BlindNinjaCore.createLevelCollection()
      signer.save(<-newLevelCollection, to: /storage/levelCollection)
      signer.link<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection, target: /storage/levelCollection)
    }

    let levelCollection: &BlindNinjaCore.LevelCollection = signer.borrow<&BlindNinjaCore.LevelCollection>(from: /storage/levelCollection)!

    let level <- ComposableLevel.createLevel(
      name: levelName,
      map: SampleLevel.Map(),
      gameObjects: [
        SampleLevel.Wall(1)
      ],
      mechanics: [],
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
