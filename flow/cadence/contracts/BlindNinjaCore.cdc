pub contract BlindNinjaCore {

  pub struct interface Map {
    
  }

  pub struct interface GameObject {
    pub var id: UInt64
    pub var type: String
    pub var doesTick: Bool
    pub var referencePoint: [Int]
    pub var relativePositions: [[Int]]

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
    pub let map: {Map}
    pub let gameObjects: [{GameObject}]
    pub let mechanics: [{GameMechanic}]
    pub let winCondition: {WinCondition}
    pub let visuals: [{VisualElement}]
  }

  // ------------------------------------------
  // End Level interface
  // ------------------------------------------

  // ------------------------------------------
  //  Public game engine functions
  // ------------------------------------------

  pub fun getInitialBoard(level: &{Level}): AnyStruct {
    let res: {String: String} = {}
    return res
  }

  pub fun tickBoard(level: &{Level}, tickCount: UInt64, objectModifications: AnyStruct, sequence: String): AnyStruct {
    let res: {String: String} = {}
    return res
  }

  // TODO: Make a 'levelCollection' to make it easy for an account to expose many levels at once.

}

