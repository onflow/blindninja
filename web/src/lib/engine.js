import * as fcl from "@onflow/fcl"

const BlindNinjaCore = "0x3b4340bde2cfd675"

function renderFrame(frame) {
    var board = new Array(Number(frame.map.viewWidth))
        .fill('').map(()=>new Array(Number(frame.map.viewHeight)).fill(''))

    let anchorX = Number(frame.map.anchorX)
    let anchorY = Number(frame.map.anchorY)

    for (const i in frame.gameObjects) {
        const objX = Number(frame.gameObjects[i].referencePoint[0] - anchorX)
        const objY = Number(frame.gameObjects[i].referencePoint[1] - anchorY)
        let obj = 'X'
        if (frame.gameObjects[i].type == 'BlindNinja') {
            obj = '🥷'
        } else if (frame.gameObjects[i].type == 'Flag') {
            obj = '🏁'
        } else if (frame.gameObjects[i].type == 'Wall') {
            obj = '🧱'
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

    pub fun main(address: Address, levelName: String): AnyStruct {
        let levelCollectionRef = getAccount(address)
            .getCapability<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection)
            .borrow()
            ?? panic("Could not borrow reference to the level collection")

        let level = levelCollectionRef.getLevel(levelName)

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

    pub fun main(address: Address, levelName: String, moveSequence: [String]): AnyStruct {
        let levelCollectionRef = getAccount(address)
            .getCapability<&{BlindNinjaCore.LevelCollectionPublic}>(/public/levelCollection)
            .borrow()
            ?? panic("Could not borrow reference to the level collection")

        let level: &{BlindNinjaCore.Level} = levelCollectionRef.getLevel(levelName)
        let levelSaveState <- BlindNinjaCore.createLevelSaveState(level, moveSequence)
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