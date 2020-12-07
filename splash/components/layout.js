import Link from 'next/link'
import Head from 'next/head'

export default function Layout({
  children,
  title = 'Fettle',
}) {
  return (
    <div className="container">
      <Head>
        <title>Fettle</title>
        <link rel="icon" href="/fettle.ico" />
      </Head>

      {children}

      <footer>{''}</footer>
      <style jsx>{`
        .container {
          padding: 0 0.5rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

      `}</style>

    </div>
  )
}