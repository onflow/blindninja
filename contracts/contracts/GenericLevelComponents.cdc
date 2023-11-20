import "BlindNinjaCore"
import "ComposableLevel"

pub contract GenericLevelComponents {

  // Provide a ninja's ID, and the ninja will move according to the current sequence number each tick
  pub struct NinjaMovement: BlindNinjaCore.GameMechanic {
    pub let name: String
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
      self.name = "Ninja Movement Mechanic"
      self.ninjaID = ninjaID
    }
  }

  pub struct GenericNinja: BlindNinjaCore.GameObject {
    pub var id: UInt64
    pub var type: String
    pub var referencePoint: [Int]

    init(id: UInt64) {
      self.id = id
      self.type = "BlindNinja"
      self.referencePoint = [0,0]
    }
  }

  pub struct Map: BlindNinjaCore.Map {
    pub let anchorX: Int
    pub let anchorY: Int
    pub let viewWidth: Int
    pub let viewHeight: Int

    init() {
      self.anchorX = 0
      self.anchorY = 0
      self.viewWidth = 20
      self.viewHeight = 20
    }
  }

  pub struct NinjaTouchGoal: BlindNinjaCore.WinCondition {
    access(all) let ninjaID: UInt64
    access(all) let goalID: UInt64

    pub fun check(_ level: &BlindNinjaCore.LevelSaveState): Bool {
      let collisionPoints = level.gameboard.newCollisionPoints
      // get collision ids at the new collision points
      for point in collisionPoints {
        let ids: [UInt64] = level.gameboard.getIDsAtPoint(point)
        var containsNinja = false
        var containsGoal = false
        for id in ids {
          containsNinja = containsNinja || id == self.ninjaID
          containsGoal = containsGoal || id == self.goalID
        }
        if (containsNinja && containsGoal) {
          return true
        }
        if (containsNinja || containsGoal) {
          return false
        }
      }
      return false
    }
    
    init(ninjaID: UInt64, goalID: UInt64) {
      self.ninjaID = ninjaID
      self.goalID = goalID
    }
  }

  pub struct Flag: BlindNinjaCore.GameObject {
    pub var id: UInt64
    pub var type: String
    pub var referencePoint: [Int]

    init(id: UInt64) {
      self.id = id
      self.type = "Flag"
      self.referencePoint = [0,0]
    }
  }
  
}