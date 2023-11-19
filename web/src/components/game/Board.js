import { Grid, Flex, Text } from '@radix-ui/themes';

const Board = ({ board }) => {
  let rows = board.length.toString()
  let cols = board[0].length.toString()

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
      {board.map((row) => (
        row.map((val) => (
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
              <Text size="9">
                {val}
              </Text>
            </Flex>
          </Flex>
        ))
      ))}

    </Grid>
  );
};

export default Board;
