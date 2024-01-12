import "BlindNinjaCore"
import "BlindNinjaLevel"

access(all) fun main(address: Address, levelName: String): AnyStruct {
  let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
  level.initializeLevel()
  let activeLevel = level.getInitialLevel()

  return {
    "name": level.name,
    "visuals": level.visuals,
    "map": activeLevel.map,
    "gameObjects": activeLevel.gameObjects
  }
}
