import "BlindNinjaCore"
import "ComposableLevel"

pub contract GenericLevelComponents {

  // Provide a ninja's ID, and the ninja will move according to the current sequence number each tick
  pub struct NinjaMovement: BlindNinjaCore.GameMechanic {
    pub let name: String
    pub let ninjaID: Int

    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let curSequence = level.sequence[level.curSequenceIndex]!
      let prevNinja = level.gameObjects[self.ninjaID]!
      let newNinja = level.gameObjects[self.ninjaID]!
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
      level.setGameObject(self.ninjaID, newNinja)
    }

    init(ninjaID: Int) {
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

/* 
  pub struct Wall: BlindNinjaCore.GameObject {
    pub var id: UInt64
    pub var type: String
    pub var doesTick: Bool
    pub var referencePoint: [Int]

    pub fun tick(
      tickCount: UInt64,
      level: &{BlindNinjaCore.Level},
      callbacks: {
        String: ((AnyStruct?): AnyStruct?)
      }
    ) {
      // do nothing
    }

    init(id: UInt64) {
      self.id = id
      self.type = "Wall"
      self.doesTick = false
      self.referencePoint = [0,0]
    }
  }

  pub struct Flag: BlindNinjaCore.GameObject {
    pub var id: UInt64
    pub var type: String
    pub var doesTick: Bool
    pub var referencePoint: [Int]

    pub fun tick(
      tickCount: UInt64,
      level: &{BlindNinjaCore.Level},
      callbacks: {
        String: ((AnyStruct?): AnyStruct?)
      }
    ) {
      // do nothing
    }

    init(id: UInt64) {
      self.id = id
      self.type = "Flag"
      self.doesTick = false
      self.referencePoint = [0,0]
    }
  }
  */

  
}