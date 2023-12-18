'use client'

import { useParams  } from 'next/navigation'
import { Container } from '@radix-ui/themes'

import * as fcl from "@onflow/fcl"

import Game from '@/components/game/Game.js'

export default function Page() {

  fcl.config({
    'accessNode.api': 'https://rest-testnet.onflow.org',
  })

  const params = useParams()

  let address = params['address']
  let levelName = params['levelName']

  return (
    <Container py="4" size="4">
      <Game
          address={address}
          levelName={levelName}
      />
    </Container>
  )
}
