
pub contract BlindNinjaCore {

  pub struct interface Map {
    pub let anchorX: Int
    pub let anchorY: Int
    pub let viewWidth: Int
    pub let viewHeight: Int
  }

  pub struct interface GameObject {
    pub var id: UInt64
    pub var type: String
    pub var doesTick: Bool
    pub var referencePoint: [Int]

    pub fun toMap(): {String: String}
    pub fun fromMap(_ map: {String: String})

    pub fun setReferencePoint(_ newReferencePoint: [Int]) {
      self.referencePoint = newReferencePoint
    }

    pub fun tick(
      tickCount: UInt64,
      level: &{Level},
      callbacks: {
        String: ((AnyStruct?): AnyStruct?)
      }
    )
  }

  pub struct interface GameMechanic {
    
  }

  pub struct interface WinCondition {

  }

  pub struct interface VisualElement {

  }

  // ------------------------------------------
  // Begin Level interface
  // ------------------------------------------
  pub resource interface Level {
    pub let name: String
    pub let map: {Map}
    pub let gameObjects: [{GameObject}]
    pub let mechanics: [{GameMechanic}]
    pub let winConditions: [{WinCondition}]
    pub let visuals: [{VisualElement}]
  }

  // ------------------------------------------
  // End Level interface
  // ------------------------------------------

  // ------------------------------------------
  // Start level collection
  // ------------------------------------------

  pub resource interface LevelCollectionPublic {
    pub fun getLevel(_ name: String): &{Level}
    pub fun getLevelNames(): [String]
  }

  pub resource LevelCollection: LevelCollectionPublic {
    pub var levels: @{String: {Level}}

    init() {
      self.levels <- {}
    }

    destroy() {
      destroy self.levels
    }

    pub fun addLevel(_ level: @{Level}) {
      let prev <- self.levels[level.name] <- level
      destroy prev
    }

    pub fun getLevel(_ name: String): &{Level} {
      return (&self.levels[name] as &{Level}?)!
    }

    pub fun getLevelNames(): [String] {
      return self.levels.keys
    }
  }

  pub fun createLevelCollection(): @LevelCollection {
    return <- create LevelCollection()
  }

  // ------------------------------------------
  // End level collection
  // ------------------------------------------

  // ------------------------------------------
  //  Public game engine functions
  // ------------------------------------------

  pub fun getInitialBoard(level: &{Level}): AnyStruct {
    let res: {String: AnyStruct} = {}
    // Provide a map of 'GameObject ID': 'Visual'
    // provide a list of extra visuals and their locations on a map
    
    return res
  }

  pub fun tickBoard(level: &{Level}, tickCount: UInt64, objects: [AnyStruct], sequence: [String], state: {String: String}): AnyStruct {
    let res: {String: String} = {}
    // return all updated objects
    // if applicable, return any extras
    // return the state
    return res
  }

  // TODO: Make a 'levelCollection' to make it easy for an account to expose many levels at once.

}

