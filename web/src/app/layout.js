import { Theme, ThemePanel } from '@radix-ui/themes'
import '@radix-ui/themes/styles.css'
import './globals.css'

import { Providers } from '@/components/providers/ThemeProvider'

export const metadata = {
  title: 'Blind Ninja',
  description: 'Flow composability demo game',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>
        <Providers>
          <Theme accentColor="grass" radius="large">
            {children}
            {/* <ThemePanel /> */}
          </Theme>
        </Providers>
      </body>
    </html>
  )
}
