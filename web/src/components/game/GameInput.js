'use client'

import { Flex, Box, Text} from '@radix-ui/themes'
import { useEffect } from 'react';

const ArrowBox = ({ children, withBorders }) => {
  const bgColor = '#dfdfdf'
  return (
    <Box style={{
      width: '100%',
      height: '55px',
      marginBottom: '10px',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      border: withBorders ? '1px solid black' : 'none',
      fontFamily: 'Arial, sans-serif',
      fontWeight: 'bold',
      backgroundColor: withBorders ? bgColor : '',
      color: 'black',
      borderRadius: '10px'
    }}>
      {children}
    </Box>
  );
}

const GameInput = ({ moves, addMove, frameIndex }) => {

  useEffect(() => {
    const handleKeyPress = (event) => {
      let key = '';
      switch (event.key) {
        case 'ArrowUp':
        case 'w':
        case 'W':
          key = 'U';
          break;
        case 'ArrowLeft':
        case 'a':
        case 'A':
          key = 'L';
          break;
        case 'ArrowDown':
        case 's':
        case 'S':
          key = 'D';
          break;
        case 'ArrowRight':
        case 'd':
        case 'D':
          key = 'R';
          break;
        default:
          return;
      }
      addMove(key);
    };

    window.addEventListener('keydown', handleKeyPress);

    return () => {
      window.removeEventListener('keydown', handleKeyPress);
    };
  }, [addMove]);


  return (
    <>
      <Flex justify="center" gap="3">
        <ArrowBox withBorders={false}></ArrowBox>
        <ArrowBox withBorders={true}>W ↑</ArrowBox>
        <ArrowBox withBorders={false}></ArrowBox>
      </Flex>
      <Flex style={{ marginTop: '-14px' }} justify="center" gap="2">
        <ArrowBox withBorders={true}>← A</ArrowBox>
        <ArrowBox withBorders={true}>S ↓</ArrowBox>
        <ArrowBox withBorders={true}>D →</ArrowBox>
      </Flex>
      <Box style={{ height: "80px", display: "flex", justifyContent: "center", alignItems: "center", flexWrap: "wrap", maxWidth: "200px" }}>
        {moves.split('').map((move, i) => {
          let key = '';
          switch (move) {
            case 'U':
              key = '↑';
              break
            case 'L':
              key = '←';
              break
            case 'R':
              key = '→';
              break
            case 'D':
              key = '↓';
              break
            default:
              key = '';
              break
          }
          const style = frameIndex > i + 1 ? { color: 'grey' } : {}
          return (<Text size={8} style={{ ...style, fontSize: '20px' }} key={i}>{key}</Text>)
        })}
      </Box>
    </>
  )
}

export default GameInput