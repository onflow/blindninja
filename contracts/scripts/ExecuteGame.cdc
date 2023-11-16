import "BlindNinjaCore"

pub fun main(address: Address, levelName: String, moveSequence: [String]): AnyStruct {
  let levelCollectionRef = getAccount(address)
    .getCapability<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection)
    .borrow()
    ?? panic("Could not borrow reference to the level collection")
  
  let level = levelCollectionRef.getLevel(levelName)

  let ticks: [BlindNinjaCore.ActiveLevel] = level.executeLevel(sequence: moveSequence)
  return ticks
}
