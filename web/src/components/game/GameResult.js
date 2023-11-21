import { useEffect } from 'react'

import { Flex, Text, Button } from '@radix-ui/themes'

const GameResult = ({ results, resetGameFunc, setBoardFunc }) => {

    var frameIndex = 0

    async function advanceFrame() {
        setTimeout(() => {
            setBoardFunc(results.frames[frameIndex])
            frameIndex++
            if (frameIndex < results.frames.length) {
                advanceFrame()
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
                disabled={!results}
            >
                Watch Again
            </Button>

            <Button
                onClick={resetGameFunc}
                disabled={!results}
            >
                Reset
            </Button>
        </Flex>
    )
}

export default GameResult