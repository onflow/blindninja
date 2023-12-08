'use client'

import { Fragment } from 'react'
import { Flex, Badge, Text } from '@radix-ui/themes'
import * as Popover from '@radix-ui/react-popover';
import { useTheme } from 'next-themes';

const GameDetails = ({ gameDetails }) => {
  const { resolvedTheme } = useTheme()
  const isDarkMode = resolvedTheme && resolvedTheme === 'dark'

  const keys = [
    {
      key: 'gameObjects',
      label: 'Objects',
      color: 'green'
    },
    {
      key: 'mechanics',
      label: 'Features',
      color: 'blue'
    },
    {
      key: 'winConditions',
      label: 'Ways to Win',
      color: 'yellow'
    }
  ]

  return (
      <Flex gap="3" justify="left">
        {
          keys.map((cur) => {
            let count = gameDetails[cur.key] ? Object.keys(gameDetails[cur.key]).length : '-'
            const typeCounts = {}
            return (
              <Popover.Root key={cur.key}>
                <Popover.Trigger>
                  <Badge style={{ cursor: 'pointer' }} color={cur.color}>{count} {cur.label}</Badge>
                </Popover.Trigger>
                <Popover.Portal>
                  <Popover.Content
                    sideOffset={5}
                    style={{
                      backgroundColor: isDarkMode ? '#2f2f2f' : '#fdfdfd',
                      border: '1px solid #1f1f1f',
                      borderRadius: '6px',
                      padding: '16px',
                      maxWidth: '300px'
                    }}
                  >
                    {
                      gameDetails[cur.key] &&
                        Object.keys(gameDetails[cur.key]).filter((index) => {
                          const type = gameDetails[cur.key][index].type.typeID
                          if (typeCounts[type]) {
                            typeCounts[type] = typeCounts[type]+1
                            return false
                          } else {
                            typeCounts[type] = 1
                            return true
                          }
                        }).sort((a, b) => {
                          return a - b
                        }).map((index, i) => {
                          const name = gameDetails[cur.key][index].data.name
                          const type = gameDetails[cur.key][index].type.typeID
                          const address = type.split('.')[1]
                          const description = gameDetails[cur.key][index].data.description
                          return (
                            <Fragment key={index}>
                              <br/>
                              <Text style={{ fontSize: '16px', style: 'bold' }}>{typeCounts[type] > 1 ? ` ${typeCounts[type]}x ` : ''}{name}
                                <Badge color="orange" style={{ cursor: 'pointer', borderRadius: '10px', padding: '1px 8px', marginLeft: '10px', fontSize: '0.8em' }}>
                                  Remix {"✏️"}
                                </Badge>
                              </Text>
                              <br/>
                              <Text style={{ fontSize: '12px', opacity: 0.7 }}>0x{address}</Text>
                              <br/>
                              <Text style={{ fontSize: '14px', lineHeight: '0.2' }}>{description}</Text>
                              <div style={{marginTop: '4px', marginBottom: '4px'}}></div>
                            </Fragment>
                          )
                        })
                    }
                  </Popover.Content>
                </Popover.Portal>
              </Popover.Root>
            )
          })
        }
      </Flex>
  )
}

export default GameDetails