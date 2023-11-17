import "BlindNinjaCore"

pub fun main(address: Address, levelName: String, moveSequence: [String]): AnyStruct {
  let levelCollectionRef = getAccount(address)
    .getCapability<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection)
    .borrow()
    ?? panic("Could not borrow reference to the level collection")
  
  let level: &{BlindNinjaCore.Level} = levelCollectionRef.getLevel(levelName)
  let levelSaveState <- BlindNinjaCore.createLevelSaveState(level, moveSequence)
  let saveState: &BlindNinjaCore.LevelSaveState = &levelSaveState as &BlindNinjaCore.LevelSaveState
  let ticks: [BlindNinjaCore.LevelResult] = level.executeFullLevel(level: saveState)
  destroy levelSaveState
  return ticks
}
