'use client'

import { Flex, Box, Text} from '@radix-ui/themes'
import { useEffect } from 'react';
import { useTheme } from 'next-themes'

const ArrowBox = ({ children, withBorders, isDarkMode }) => {
  const bgColor = isDarkMode ? '#333' : '#dfdfdf'
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
      borderRadius: '10px'
    }}>
      {children}
    </Box>
  );
}

const GameInput = ({ moves, addMove, frameIndex }) => {
  const { resolvedTheme } = useTheme()
  const isDarkMode = !resolvedTheme || resolvedTheme === 'dark'

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
        <ArrowBox withBorders={false} isDarkMode={isDarkMode}></ArrowBox>
        <ArrowBox withBorders={true} isDarkMode={isDarkMode}>W ↑</ArrowBox>
        <ArrowBox withBorders={false} isDarkMode={isDarkMode}></ArrowBox>
      </Flex>
      <Flex style={{ marginTop: '-14px' }} justify="center" gap="2">
        <ArrowBox withBorders={true} isDarkMode={isDarkMode}>← A</ArrowBox>
        <ArrowBox withBorders={true} isDarkMode={isDarkMode}>S ↓</ArrowBox>
        <ArrowBox withBorders={true} isDarkMode={isDarkMode}>D →</ArrowBox>
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