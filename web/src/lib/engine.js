import * as fcl from "@onflow/fcl"

const BlindNinjaCore = "0x598e55be1da28f73"

function renderFrame(frame) {
    var board = new Array(Number(frame.map.viewWidth))
        .fill('').map(()=>new Array(Number(frame.map.viewHeight)).fill(''))

    let anchorX = Number(frame.map.anchorX)
    let anchorY = Number(frame.map.anchorY)

    for (const i in frame.gameObjects) {
        const objX = Number(frame.gameObjects[i].referencePoint[0] - anchorX)
        const objY = Number(frame.gameObjects[i].referencePoint[1] - anchorY)
        let obj = 'X'
        if (frame.gameObjects[i].display) {
            obj = frame.gameObjects[i].display
        }
        if (objX >= 0 && objX < board.length && objY >= 0 && objY < board[0].length) {
            board[objY][objX] = obj
        }
    }
    return board
}

export async function getInitialBoard(address, levelName) {
    const script = `
        import BlindNinjaCore from ${BlindNinjaCore}
        import BlindNinjaLevel from ${BlindNinjaCore}

        pub fun main(address: Address, levelName: String): AnyStruct {
            let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
            level.initializeLevel()
            let activeLevel = level.getInitialLevel()

            return {
                "name": level.name,
                "visuals": level.visuals,
                "map": activeLevel.map,
                "gameObjects": activeLevel.gameObjects
            }
        }
    `
    const result = await fcl.query({
        cadence: script,
        args: (arg, t) => [
            arg(address, t.Address),
            arg(levelName, t.String),
        ]
    })

    console.log("getInitialBoard", result)

    return renderFrame(result)
}

export async function executeLevel(address, levelName, moves) {
    const script = `
        import BlindNinjaCore from ${BlindNinjaCore}
        import BlindNinjaLevel from ${BlindNinjaCore}
        
        pub fun main(address: Address, levelName: String, moveSequence: [String]): AnyStruct {
            let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
            level.initializeLevel()
            
            let levelSaveState: @BlindNinjaCore.LevelSaveState <- BlindNinjaCore.createLevelSaveState(
                address: address,
                levelName: levelName,
                map: level.map,
                gameObjects: level.gameObjects,
                gameboard: level.gameboard,
                state: level.state,
                moveSequence: moveSequence,
            )
            let saveState: &BlindNinjaCore.LevelSaveState = &levelSaveState as &BlindNinjaCore.LevelSaveState
            let ticks: [BlindNinjaCore.LevelResult] = level.executeFullLevel(level: saveState)
            destroy levelSaveState
            
            return ticks
        }
    `
    var movesArray = []
    for (const m of moves) {
        switch (m) {
            case 'U':
                movesArray.push('ArrowUp')
                break
            case 'D':
                movesArray.push('ArrowDown')
                break
            case 'L':
                movesArray.push('ArrowLeft')
                break
            case 'R':
                movesArray.push('ArrowRight')
                break
        }
    }

    const result = await fcl.query({
        cadence: script,
        args: (arg, t) => [
            arg(address, t.Address),
            arg(levelName, t.String),
            arg(movesArray, t.Array(t.String)),
        ]
    })

    console.log("executeLevel", result)

    var haswon = false
    var frames = []
    for (const f of result) {
        if (f.hasWonGame) {
            haswon = true
        }
        frames.push(renderFrame(f))
    }

    return { frames, haswon }
}