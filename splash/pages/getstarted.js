import { useEffect, useState, useRef } from 'react'
import Layout from '../components/layout'
import NavigationBar from '../components/NavigationBar'

export default function Test() {

  const [headerIndex, setHeaderIndex] = useState(0);
  const [subHeaderIndex, setSubHeaderIndex] = useState(0);

  const headings = ['Create an account or log-in with your email address', 'Name yourself and connect to your step tracker', 'You will be directed to the homepage',
    'Buy tickets and fly to foreign countries', 'Collect and wear clothes from each country', 'Exchange the coins you earned for vouchers',
    'Schedule a workout session with your friends.', 'View which friends agreed to join the session', 'Start the workout session', 'End the workout session',
    'Check your stats', 'Check your friends stats', 'Add a friend', 'Chat with a friend', 'Receive notifications in the app', 'Receive push notifications too']

  const gifURLs = [
    '/createacc.gif',
    '/googlefit.gif',
    '/homepage.gif',
    '/flytojapan.gif',
    '/japblack.gif',
    '/tasknrewards.gif',
    '/scheduleworkoutnew.gif',
    '/viewattendees.gif',
    '/workoutstart.gif',
    '/workoutend.gif',
    '/userstats.gif',
    '/friendstat.gif',
    '/addfriend.gif',
    '/chatwfriend.gif',
    '/inbox.gif',
    '/pushnotifnchat.gif',
  ]

  useEffect(() => {
    // Update the document title using the browser API
    setSubHeaderIndex(headerObjects[headerIndex].subHeaders[0].index);
  }, [headerIndex]);

  const headerObjects = [
    {
      index: 0,
      header: 'Onboarding',
      subHeaders: [
        { heading: 'Create Account', index: 0 },
        { heading: 'Connect to Google Fit', index: 1 },
        { heading: 'Homepage', index: 2 }
      ]
    },
    {
      index: 1,
      header: 'Rewards',
      subHeaders: [
        { heading: 'Fly Anywhere', index: 3 },
        { heading: 'Buy Costumes', index: 4 },
        { heading: 'Complete Tasks to Redeem Rewards', index: 5 },
      ]
    },
    {
      index: 2,
      header: 'Workout',
      subHeaders: [
        { heading: 'Schedule a new Workout Session', index: 6 },
        { heading: 'View Attendees', index: 7 },
        { heading: 'Start the Workout', index: 8 },
        { heading: 'End the Workout', index: 9 },
      ]
    },
    {
      index: 3,
      header: 'Social',
      subHeaders: [
        { heading: 'Check User Stats', index: 10 },
        { heading: 'Check on your Friends', index: 11 },
        { heading: 'Add a new Friend', index: 12 },
        { heading: 'Chat with Your Friends', index: 13 },
        { heading: 'Inbox', index: 14 },
        { heading: 'Notification', index: 15 },
      ]
    },
  ]

  return <div>
    <Layout />
    <NavigationBar />
    <main>
      <h1 className="leading-none text-4xl font-extrabold">
        Using <span className="magical-gradient">Fettle</span>
      </h1>

      <div className="carousel-header">
        {
          headerObjects.map(headerObject => <button className={(headerIndex == headerObject.index ? '' : 'button-not-active ') + 'btn btn-blue header-btn'} onClick={() => setHeaderIndex(headerObject.index)}>{headerObject.header}</button>)
        }
      </div>

      <div className="carousel-header">
        {
          headerObjects[headerIndex].subHeaders.map(subHeader => <button className={(subHeaderIndex == subHeader.index ? '' : 'button-not-active ') + 'btn btn-success sub-header-btn'} onClick={() => setSubHeaderIndex(subHeader.index)} >{subHeader.heading}</button>)
        }
      </div>

      <p>{headings[subHeaderIndex]}</p>

      <div>
        <button onClick={() => subHeaderIndex == 0 ? setSubHeaderIndex(15) : setSubHeaderIndex(subHeaderIndex - 1)} className="button button5">{'<<'}</button>
        <img className="gifs" src={gifURLs[subHeaderIndex]} />
        <button onClick={() => subHeaderIndex == gifURLs.length - 1 ? setSubHeaderIndex(0) : setSubHeaderIndex(subHeaderIndex + 1)} className="button button5">{'>>'}</button>
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
  </div >

}