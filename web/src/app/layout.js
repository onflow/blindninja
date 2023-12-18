import { Theme, Flex } from '@radix-ui/themes'
import '@radix-ui/themes/styles.css'
import './globals.css'

import { Providers } from '@/components/providers/ThemeProvider'

import Navbar from '@/components/ui/Navbar.js'

export const metadata = {
  title: 'Blind Ninja',
  description: 'Flow composability demo game',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body  suppressHydrationWarning>
        <Providers>
          <Theme accentColor="grass" radius="large">
          <Flex direction="column" style={{ height: '100vh'}}>
            <Navbar/>
            {children}
          </Flex>
          {/* <ThemePanel /> */}
          </Theme>
        </Providers>
      </body>
    </html>
  )
}
