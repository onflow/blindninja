import { Grid, Flex, Text } from '@radix-ui/themes';

const Board = ({ board }) => {
  let loading = true
  var rows = 1, cols = 1
  if (board) {
    loading = false
    rows = board.length.toString()
    cols = board[0].length.toString()
  }

  let maxDim = Math.max(rows, cols)

  var cellFontSize = '1'
  if (maxDim < 10) {
    cellFontSize = '9'
  } else if (maxDim < 20) {
    cellFontSize = '8'
  } else if (maxDim < 25) {
    cellFontSize = '7'
  } else if (maxDim < 30) {
    cellFontSize = '6'
  } else if (maxDim < 35) {
    cellFontSize = '5'
  } else if (maxDim < 40) {
    cellFontSize = '4'
  } else if (maxDim < 45) {
    cellFontSize = '3'
  } else if (maxDim < 50) {
    cellFontSize = '2'
  }

  return (
    <Grid
      rows={rows}
      columns={cols}
      height="100%"
      style={{
        borderLeftWidth: 1,
        borderBottomWidth: 1,
        borderStyle: 'solid',
        borderColor: 'var(--gray-a7)',
      }}
    >
      {loading ? (
        <Flex
          justify="center"
          direction="column"
          style={{
            borderRightWidth: 1,
            borderTopWidth: 1,
            borderStyle: 'solid',
            borderColor: 'var(--gray-a7)',
          }}
        >
          <Flex justify="center">
            <Text size="6">
              Loading ...
            </Text>
          </Flex>
        </Flex>
      ) : (
        <>
          {board.map((row, rowIndex) => (
            row.map((val, colIndex) => (
              <Flex
                justify="center"
                direction="column"
                key={rowIndex.toString() + colIndex.toString()}
                style={{
                  borderRightWidth: 1,
                  borderTopWidth: 1,
                  borderStyle: 'solid',
                  borderColor: 'var(--gray-a7)',
                }}
              >
                <Flex justify="center">
                  <Text size={cellFontSize}>
                    {val}
                  </Text>
                </Flex>
              </Flex>
            ))
          ))}
        </>
      )}
    </Grid>
  );
};

export default Board;
