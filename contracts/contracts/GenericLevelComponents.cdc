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
      self.name = "Ninja Movement"
      self.ninjaID = ninjaID
    }
  }

  // Prevents a ninja from coinciding with a wall
  pub struct WallMechanic: BlindNinjaCore.GameMechanic {
    pub let name: String
    pub let ninjaID: UInt64
    pub let wallType: Type

    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      // Check through the new collisions that have come up,
      // If any have to do with the ninja colliding with a
      // wall type, then revert the ninja to go back to its
      // location from the previous game result.
      let collisionPoints = level.gameboard.newCollisionPoints
      
      var ninjaHasRunIntoWall = false
      for point in collisionPoints {
        let ids: [UInt64] = level.gameboard.getIDsAtPoint(point)
        var containsNinja = false
        var containsWallType = false
        for id in ids {
          containsNinja = containsNinja || id == self.ninjaID
          containsWallType = containsWallType || self.wallType == level.gameObjects[Int(id)]!.getType()
        }
        if (containsNinja && containsWallType) {
          ninjaHasRunIntoWall = true
          break
        }
        if (containsNinja || containsWallType) {
          ninjaHasRunIntoWall = false
          break
        }
      }

      if (ninjaHasRunIntoWall) {
        // If the ninja is currently running into a wall,
        // revert the ninja to its previous position from before
        // this move.
        let prevNinja = level.tickResults[Int(level.tickResults.length - 1)]!.gameObjects[Int(self.ninjaID)]!
        let curNinja = level.gameObjects[Int(self.ninjaID)]!
        level.gameboard.remove(curNinja)
        level.gameboard.add(prevNinja)
        level.setGameObject(Int(self.ninjaID), prevNinja)
      }
    }

    init(ninjaID: UInt64, wallType: Type) {
      self.name = "Wall blocks ninja"
      self.ninjaID = ninjaID
      self.wallType = wallType
    }
  }

  // This works best if the original size of the map is made up
  // of an odd width and height, so that the center can be actually
  // be in the center, rather than one-off
  // This mechanic does not center the ninja in the initial state,
  // that should be manually done by the game itself at creation time.
  pub struct CenteredCamera: BlindNinjaCore.GameMechanic {
    pub let name: String
    pub let centeredObjectID: UInt64

    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let centeredObjectLocation: [Int] = level.gameObjects[Int(self.centeredObjectID)]!.referencePoint
      let newAnchorX = centeredObjectLocation[0]! - (level.map.viewWidth/2)
      let newAnchorY = centeredObjectLocation[1]! - (level.map.viewHeight/2)
      let newMap: Map = Map(
        anchorX: newAnchorX,
        anchorY: newAnchorY,
        viewWidth: level.map.viewWidth,
        viewHeight: level.map.viewHeight
      )
      level.setMap(newMap)
    }

    init(centeredObjectID: UInt64) {
      self.name = "Centered Camera"
      self.centeredObjectID = centeredObjectID
    }
  }

  pub struct Map: BlindNinjaCore.Map {
    pub let anchorX: Int
    pub let anchorY: Int
    pub let viewWidth: Int
    pub let viewHeight: Int

    init(anchorX: Int, anchorY: Int, viewWidth: Int, viewHeight: Int) {
      self.anchorX = anchorX
      self.anchorY = anchorY
      self.viewWidth = viewWidth
      self.viewHeight = viewHeight
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

  pub struct Wall: BlindNinjaCore.GameObject {
    pub var id: UInt64
    pub var type: String
    pub var referencePoint: [Int]

    init(id: UInt64) {
      self.id = id
      self.type = "Wall"
      self.referencePoint = [0,0]
    }
  }
  
}