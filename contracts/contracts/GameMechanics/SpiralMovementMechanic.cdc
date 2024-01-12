import "BlindNinjaCore"
import "BlindNinjaMechanic"

access(all) contract SpiralMovementMechanic: BlindNinjaMechanic {
  access(all) struct Mechanic: BlindNinjaCore.GameMechanic {
    access(all) let name: String
    access(all) let description: String
    access(all) let objectID: UInt64
    access(all) let directions: [String]

    access(all) fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let curSequence = level.sequence[level.curSequenceIndex]!
      let prevObj = level.getGameObject(Int(self.objectID))!
      let newObj = level.getGameObject(Int(self.objectID))!
      let existingPoint = newObj.referencePoint
      
      var dist: AnyStruct? = level.getState("curDistanceTravelled")
      if (dist == nil) {
        level.setState("curDistanceTravelled", 0)
      }
      var distToReach: AnyStruct? = level.getState("distanceToReach")
      if (distToReach == nil) {
        level.setState("distanceToReach", 3)
      }
      var dirIndex: AnyStruct? = level.getState("directionIndex")
      if (dirIndex == nil) {
        level.setState("directionIndex", 0)
      }

      var curDistanceTravelled = level.getState("curDistanceTravelled")! as! Int
      var distanceToReach = level.getState("distanceToReach")! as! Int
      var directionIndex = level.getState("directionIndex")! as! Int
      

      if (curDistanceTravelled == distanceToReach) {
        directionIndex = (directionIndex + 1) % self.directions.length
        curDistanceTravelled = 0
        distanceToReach = distanceToReach + 1
      } else {
        curDistanceTravelled = curDistanceTravelled + 1
      }

      level.setState("curDistanceTravelled", curDistanceTravelled)
      level.setState("distanceToReach", distanceToReach)
      level.setState("directionIndex", directionIndex)

      if (self.directions[directionIndex] == "DOWN") {
        newObj.setReferencePoint([existingPoint[0]!, existingPoint[1]! + 1])
      }
      if (self.directions[directionIndex] == "UP") {
        newObj.setReferencePoint([existingPoint[0]!, existingPoint[1]! - 1])
      }
      if (self.directions[directionIndex] == "RIGHT") {
        newObj.setReferencePoint([existingPoint[0]! + 1, existingPoint[1]!])
      }
      if (self.directions[directionIndex] == "LEFT") {
        newObj.setReferencePoint([existingPoint[0]! - 1, existingPoint[1]!])
      }
      level.gameboard.remove(prevObj)
      level.gameboard.add(newObj)
      level.setGameObject(Int(self.objectID), newObj)
    }

    init(objectID: UInt64) {
      self.name = "Spiral Movement"
      self.description = "This mechanic makes it so that the given object is forced to move on every tick in a spiral motion that gets larger and larger."
      self.objectID = objectID
      self.directions = ["UP", "LEFT", "DOWN", "RIGHT"]
    }
  }
}