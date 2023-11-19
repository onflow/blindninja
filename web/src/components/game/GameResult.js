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

    return (
        <Flex gap="3" direction="column">

            {results ? (
                <Text>Result: {results.winloss}</Text>
            ):(
                <Text>Waiting for player</Text>
            )}

            <Button
                onClick={advanceFrame}
                disabled={!results}
            >
                Play Result
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