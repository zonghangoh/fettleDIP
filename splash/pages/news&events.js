import Layout from '../components/layout'
import NavigationBar from '../components/NavigationBar'

export default function NewsEvents() {
  return (<>
    <Layout />
    <NavigationBar />
    <div className="container">


      <main>
        <h1 className="leading-none text-4xl font-extrabold">
          What's <span className="magical-gradient">New</span>: Fettle
        </h1>

        <p className="description">
          ___________________________
        </p>

      </main>

      <style jsx>{`

        main {
          padding: 5rem 0;
          flex: 1;
          display: flex;
          flex-direction: column;
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

        code {
          background: #fafafa;
          border-radius: 5px;
          padding: 0.75rem;
          font-size: 1.1rem;
          font-family: Menlo, Monaco, Lucida Console, Liberation Mono,
            DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace;
        }

        .grid {
          display: flex;
          align-items: center;
          justify-content: center;
          flex-wrap: wrap;

          max-width: 800px;
          margin-top: 3rem;
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

    <div className="newscontainer justify-content-center ml-auto mx-auto">
      <main>
        <div class="card-deck">
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">11.11 Sales!</h5>
              <p class="card-text">80% discount on all shop items!</p>
              <p class="card-text"><small class="text-muted">Last updated 5 mins ago</small></p>
            </div>
          </div>
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">New Release: Golden Mouse Hunting</h5>
              <p class="card-text">Squeak Squeak Squeak! Hop on to our new event: Golden Mouse Hunting!</p>
              <p class="card-text"><small class="text-muted">Last updated 1 day ago</small></p>
            </div>
          </div>
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">Halloween Special Sales!</h5>
              <p class="card-text">Welcome to Fettle! A place where you will never have to excerise alone again.</p>
              <p class="card-text"><small class="text-muted">Last updated 11 days ago</small></p>
            </div>
          </div>
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">New shop items: NTU & IEM apparel!</h5>
              <p class="card-text">NTU & IEM shirts are up on shop NOW!</p>
              <p class="card-text"><small class="text-muted">Last updated 20 days ago</small></p>
            </div>
          </div>
        </div>

        <div class="card-deck pt-5">
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">Server Maintenance 1st November</h5>
              <p class="card-text">Server will be down for maintenance from 9am to 3pm GMT +8</p>
              <p class="card-text"><small class="text-muted">Last updated 1 month ago</small></p>
            </div>
          </div>
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">Earn more points: Step Tracker</h5>
              <p class="card-text">Connect with your Google Fit to join us today!</p>
              <p class="card-text"><small class="text-muted">Last updated 2 months ago</small></p>
            </div>
          </div>
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">Server Maintenance 10th October</h5>
              <p class="card-text">Server will be down for maintenance from 9am to 3pm GMT +8</p>
              <p class="card-text"><small class="text-muted">Last updated 3 months ago</small></p>
            </div>
          </div>
          <div class="card" align="center">
            <img class="card-img-top" src="..." alt="Card image cap" />
            <div class="card-body">
              <h5 class="card-title">Opening of Fettle!</h5>
              <p class="card-text">Welcome to Fettle! A place where you will never have to excerise alone again.</p>
              <p class="card-text"><small class="text-muted">Last updated 3 months ago</small></p>
            </div>
          </div>
        </div>
      </main>

      <style jsx>{`

        .newscontainer {
            min-height: 10vh;
            padding: 10 10rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        main {
        padding: 1rem 0;
        flex: 1;
        display: flex;
        flex-direction: column;
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

        code {
        background: #fafafa;
        border-radius: 5px;
        padding: 0.75rem;
        font-size: 1.1rem;
        font-family: Menlo, Monaco, Lucida Console, Liberation Mono,
            DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace;
        }

        max-width: 1000px;
        margin-top: 0rem;
        

        .card {
        margin: 1rem;
        flex-basis: 45%;
        padding: 1.5rem;
        text-align: center;
        color: inherit;
        text-decoration: none;
        border: 1px solid #eaeaea;
        border-radius: 10px;
        transition: color 0.15s ease, border-color 0.15s ease;
        }

        .card:hover,
        .card:focus,
        .card:active {
        color: #0070f3;
        border-color: #0070f3;
        }

        .card h3 {
        margin: 0 0 1rem 0;
        font-size: 1.5rem;
        }

        .card p {
        margin: 0;
        font-size: 1.25rem;
        line-height: 1.5;
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
    </div>


    <div className="footercontainer">

      <footer>
        powered by passion
      </footer>


      <style jsx>{`
        .footercontainer {
          min-height: 50vh;
          padding: 0 0.5rem;
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

        .logo {
          height: 1em;
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