import "BlindNinjaCore"
import "BlindNinjaLevel"

pub fun main(address: Address, levelName: String, moveSequence: [String]): AnyStruct {
  let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
  level.initializeLevel()

  let levelSaveState: @BlindNinjaCore.LevelSaveState <- BlindNinjaCore.createLevelSaveState(
    address: address,
    levelName: levelName,
    map: level.map,
    gameObjects: level.gameObjects,
    gameboard: level.gameboard,
    state: level.state,
    moveSequence: moveSequence,
  )
  let saveState: &BlindNinjaCore.LevelSaveState = &levelSaveState as &BlindNinjaCore.LevelSaveState
  let ticks: [BlindNinjaCore.LevelResult] = level.executeFullLevel(level: saveState)
  destroy levelSaveState

  return ticks
}
