import "BlindNinjaCore"

pub fun main(address: Address, levelName: String): AnyStruct {
  let levelCollectionRef = getAccount(address)
    .getCapability<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection)
    .borrow()
    ?? panic("Could not borrow reference to the level collection")
  
  let level = levelCollectionRef.getLevel(levelName)

  let activeLevel = level.getInitialLevel()
  return {
    "name": level.name,
    "visuals": level.visuals,
    "map": activeLevel.map,
    "gameObjects": activeLevel.gameObjects
  }
}
