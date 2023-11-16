import "BlindNinjaCore"
import "ComposableLevel"

pub contract GenericLevelComponents {

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