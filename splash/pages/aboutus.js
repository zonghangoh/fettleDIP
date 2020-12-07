import Layout from '../components/layout'
import NavigationBar from '../components/NavigationBar'

export default function AboutUs() {
  return (<>
    <Layout />
    <NavigationBar />
    <div className="container">


      {/*<img src="/fettle2.ico" class="img-fluid" alt="Responsive image"></img> */}
      <main>
        <h1 className="leading-none text-4xl font-extrabold">
          About <span className="magical-gradient">Us</span>
        </h1>

        <p className="description">
          _______________________
        </p>
        <p></p>
        <p></p>

        <div class="card">
          <div class="card-body">
            <p class="mb-0">We are a group of students from Nanyang Technological University, Information Engineering and Media.
            </p>
          </div>
        </div>
      </main>

      <footer>
        powered by passion
      </footer>

      <style jsx>{`

        main {
          padding: 5rem 0;
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        footer {
          width: 100%;
          height: 100px;
          border-top: 1px solid #eaeaea;
          display: flex;
          justify-content: center;
          align-items: center;
        }

        footer img {
          margin-left: 0.5rem;
        }

        footer a {
          display: flex;
          justify-content: center;
          align-items: center;
        }

        a {
          color: inherit;
          text-decoration: none;
        }

        .title a {
          color: #0070f3;
          text-decoration: none;
        }

        .title a:hover,
        .title a:focus,
        .title a:active {
          text-decoration: underline;
        }

        .title {
          margin: 0;
          line-height: 1.15;
          font-size: 4rem;
        }

        .title,
        .description {
          text-align: center;
        }

        .description {
          line-height: 1.5;
          font-size: 1.5rem;
        }

        

        .logo {
          height: 1em;
        }

        @media (max-width: 600px) {
          .grid {
            width: 100%;
            flex-direction: column;
          }
        }
      `}</style>

      <style jsx global>{`
        html,
        body {
          padding: 0;
          margin: 0;
          font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto,
            Oxygen, Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue,
            sans-serif;
        }

        * {
          box-sizing: border-box;
        }
      `}</style>
    </div>
  </>
  )
}