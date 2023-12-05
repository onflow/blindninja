import "BlindNinjaCore"
import "BlindNinjaMechanic"

pub contract NinjaMovementMechanic: BlindNinjaMechanic {
  pub struct Mechanic: BlindNinjaCore.GameMechanic {
    pub let name: String
    pub let description: String
    pub let ninjaID: UInt64

    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let curSequence = level.sequence[level.curSequenceIndex]!
      let prevNinja = level.gameObjects[Int(self.ninjaID)]!
      let newNinja = level.gameObjects[Int(self.ninjaID)]!
      let existingPoint = newNinja.referencePoint
      if (curSequence == "ArrowDown") {
        newNinja.setReferencePoint([existingPoint[0]!, existingPoint[1]! + 1])
      }
      if (curSequence == "ArrowUp") {
        newNinja.setReferencePoint([existingPoint[0]!, existingPoint[1]! - 1])
      }
      if (curSequence == "ArrowRight") {
        newNinja.setReferencePoint([existingPoint[0]! + 1, existingPoint[1]!])
      }
      if (curSequence == "ArrowLeft") {
        newNinja.setReferencePoint([existingPoint[0]! - 1, existingPoint[1]!])
      }
      level.gameboard.remove(prevNinja)
      level.gameboard.add(newNinja)
      level.setGameObject(Int(self.ninjaID), newNinja)
    }

    init(ninjaID: UInt64) {
      self.name = "Ninja Movement"
      self.description = "This mechanic allows a ninja to move according to the current sequence number each tick."
      self.ninjaID = ninjaID
    }
  }
}