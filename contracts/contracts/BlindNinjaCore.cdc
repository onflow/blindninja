
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

  pub struct ActiveLevel {
    pub let map: {Map}
    pub let gameObjects: [{GameObject}]

    init(map: {Map}, gameObjects: [{GameObject}]) {
      self.map = map
      self.gameObjects = gameObjects
    }
  }

  // ------------------------------------------
  // Begin Level interface
  // ------------------------------------------
  pub resource interface Level {
    access(all) let name: String

    // The map and gameobjects can and likely will change during
    //  a game to represent changes in view or gameobject,
    // so when a game starts they are copied to a new
    // struct for the 'ActiveLevel'
    access(all) let map: {Map}
    access(all) let gameObjects: [{GameObject}]

    // ------ Static modifiers that control the level --------
    // the below are static objects, and not included in an 'activelevel'

    // Mechanics are run on every tick, according to the type of mechanic.
    //  i.e. a collision mechanic will be run whenever a collision occurs between
    //       2 game objects.
    // TODO: Determine all type of mechanics, and plug them in appropriately.
    access(all) let mechanics: [{GameMechanic}]

    // Win conditions decide how a game could be won.
    // The game's tick will always check if the win conditions are satisfied
    // on each iteration.
    access(all) let winConditions: [{WinCondition}]

    // Static visuals that do not tick, and are in the background of the game.
    // This also can be used to associate an ID to a visual element for it.
    // This allows you to decouple the gameobjects from their visual counterpart.
    access(all) let visuals: [{VisualElement}]

    // ------ End Static modifiers --------

    // ------ Game Execution --------
    access(all) fun executeLevel(ninja: {GameObject}, sequence: [String]): [ActiveLevel] {
      var results: [ActiveLevel] = []
      var i: Int = 0
      let activeLevel = BlindNinjaCore.ActiveLevel(
        map: self.map,
        gameObjects: [ninja].concat(self.gameObjects)
      )
      while (i < sequence.length) {
        let curResult = self.tickLevel(activeLevel: activeLevel, curSequence: sequence[i])
        results.append(curResult)
        i = i + 1
      }

      return results
    }

    access(all) fun tickLevel(activeLevel: ActiveLevel, curSequence: String): ActiveLevel
    // ------ End Game Execution -------
  
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

    pub fun removeLevel(_ name: String): @{Level}? {
      let level <- self.levels.remove(key: name)
      return <-level
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
}

