import "BlindNinjaCore"
import "BlindNinjaMechanic"

pub contract SpiralMovementMechanic: BlindNinjaMechanic {
  pub struct Mechanic: BlindNinjaCore.GameMechanic {
    pub let name: String
    pub let description: String
    pub let objectID: UInt64
    pub let directions: [String]

    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let curSequence = level.sequence[level.curSequenceIndex]!
      let prevObj = level.gameObjects[Int(self.objectID)]!
      let newObj = level.gameObjects[Int(self.objectID)]!
      let existingPoint = newObj.referencePoint
      
      var dist: AnyStruct? = level.state["curDistanceTravelled"]
      if (dist == nil) {
        level.setState("curDistanceTravelled", 0)
      }
      var distToReach: AnyStruct? = level.state["distanceToReach"]
      if (distToReach == nil) {
        level.setState("distanceToReach", 3)
      }
      var dirIndex: AnyStruct? = level.state["directionIndex"]
      if (dirIndex == nil) {
        level.setState("directionIndex", 0)
      }

      var curDistanceTravelled = level.state["curDistanceTravelled"]! as! Int
      var distanceToReach = level.state["distanceToReach"]! as! Int
      var directionIndex = level.state["directionIndex"]! as! Int
      

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