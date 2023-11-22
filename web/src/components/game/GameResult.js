import { useEffect, useState } from 'react'

import { Flex, Text, Button } from '@radix-ui/themes'

const GameResult = ({ results, resetGameFunc, setBoardFunc }) => {

    var frameIndex = 0
    var [ playing, setPlaying ] = useState(false)

    async function advanceFrame() {
        setPlaying(true)
        setTimeout(() => {
            setBoardFunc(results.frames[frameIndex])
            frameIndex++
            if (frameIndex < results.frames.length) {
                advanceFrame()
            } else {
                setPlaying(false)
            }
        }, 200)
    }

    useEffect(() => {
        if (results) {
            advanceFrame()
        }
    }, [results])

    return (
        <Flex gap="3" direction="column">

            {results ? (

                <Flex gap="2">
                    <Text>Win: </Text>
                    <Text
                        weight="bold"
                        color={results.haswon? 'green': 'red'}
                    >
                        {results.haswon? 'Yes': 'No'}
                    </Text>
                </Flex>
            ):(
                <Text>Waiting for player</Text>
            )}

            <Button
                onClick={advanceFrame}
                disabled={!results || playing}
            >
                Watch Again
            </Button>

            <Button
                onClick={resetGameFunc}
                disabled={!results || playing}
            >
                Reset
            </Button>
        </Flex>
    )
}

export default GameResult