import Head from 'next/head'
import React from "react"
import NavigationBar from '../components/NavigationBar'
import Lottie from 'react-lottie';
import catwave from '../public/IEMCatBlackWaving.json'
import pushups from '../public/pushups.json'
import situps from '../public/situps.json'
import squats from '../public/squats.json'
import Layout from '../components/layout'

import japan from '../public/JapanCatPinkKimonoBouncing.json'
import hawaii from '../public/HawaiiCatBouncing.json'
import iem from '../public/IEMCatWhiteBouncing.json'
import ntu from '../public/NTUCatRedBouncing.json'
import Popup from 'reactjs-popup';
import 'reactjs-popup/dist/index.css';

export default function Home() {
  const defaultOptions = {
    loop: true,
    autoplay: true,
    animationData: catwave,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const pushupOptions = {
    loop: true,
    autoplay: true,
    animationData: pushups,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const situpOptions = {
    loop: true,
    autoplay: true,
    animationData: situps,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const squatOptions = {
    loop: true,
    autoplay: true,
    animationData: squats,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const hawaiiCat = {
    loop: true,
    autoplay: true,
    animationData: hawaii,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const iemCat = {
    loop: true,
    autoplay: true,
    animationData: iem,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const ntuCat = {
    loop: true,
    autoplay: true,
    animationData: ntu,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };

  const japanCat = {
    loop: true,
    autoplay: true,
    animationData: japan,
    rendererSettings: {
      preserveAspectRatio: 'xMidYMid slice'
    }
  };


  return (<>
    <Layout />
    <NavigationBar />

    <div className="container">
      <br /> <br /> <br />
      <div className="row">
        <div className="col-md">
          <h1 className="leading-none text-4xl font-extrabold">
            A cuter way to <span className="magical-gradient">stay fit with friends 🐱</span>
          </h1>


          <br />
          <div className="buttons">
            {/* <p></p> */}
            <Popup trigger={<button class="btn btn-blue btn-lg" role="button">Watch Tour</button>} modal>
              <div align='center' className="videocontainer">

                {/* <div class="embed-responsive embed-responsive-16by9 w-100"> */}
                <iframe width="640" height="360" src="https://www.youtube.com/embed/eQ_FJ-LqEHg"></iframe>
                {/* </div> */}

              </div>
            </Popup>

          </div>
        </div>
        <div className="col-md">
          <Lottie options={defaultOptions}
            height={400}
            width={400}
            isStopped={false}
            isPaused={false} />
        </div>

      </div>

      <style jsx>{`
        .videocontainer{
          background: transparent !important;
        }

        .popup-content {
          background: transparent !important;
        }

        .container {
          min-height: 50vh;
          padding: 0 0.5rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

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


    <div className=" bg-light text-black">
      <br />  <br />  <br />
      <div className='container'>
        <div className="row">
          <div className="col-md img-bottom">
            <img src='/steps.png' width='100%' className="img-fluid" />
          </div>
          <div className="col">
            <h4 className="leading-none text-3xl font-extrabold">
              If you want to walk fast, walk alone.<span className="magical-gradient">If you want to walk far, walk together.</span>
            </h4>
            <br />
            <p className="lead"> Sync up with your Apple Health or Google Fit account and complete step challenges with your friends in exchange for vouchers and rewards. Build lasting healthy habits with the people you care about, step by step!</p>
            <br /> <br />
          </div>

        </div>
      </div>

      <style jsx>{`
        .exercisecontainer {
          min-height: 50vh;
          display: flex;
        }

        row {
          flex-direction: column;
        }

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

        .card {
          margin: 1rem;
          flex-basis: 45%;
          padding: 1.5rem;
          text-align: left;
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



    <div className="container">
      <br />  <br />  <br />
      <div className="row">
        <div className="col">

          <h4 className="leading-none text-3xl font-extrabold">
            Jio your friends for <span className="magical-gradient">5 minute Tabata workouts through live video</span>

          </h4>
          <br />
          {/* <p className="lead"> HPB-issued step trackers are cool, but we've now made them social by letting you share your step activity with friends. Motivate or get motivated by your peers to build healthy habits!</p> */}
          <div class="row">
            <div class="col" align="center">
              <Lottie options={pushupOptions}
                height={80}
                width={80}
                isStopped={false}
                isPaused={false} />
              <small><b>Push Ups</b></small>
              <p></p>
            </div>

            <div class="col" align="center">
              <Lottie options={situpOptions}
                height={80}
                width={80}
                isStopped={false}
                isPaused={false} />
              <small><b>Sit Ups</b></small>
              <p></p>
            </div>

            <div class="col" align="center">
              <Lottie options={squatOptions}
                height={80}
                width={80}
                isStopped={false}
                isPaused={false} />
              <small><b>Squats</b></small>
              <p></p>
            </div>

          </div>
          <br /> <br />
        </div>

        <div className="col-md img-bottom">
          <img src='/cat.png' width='100%' className="img-fluid" />
        </div>


      </div>

      {/* <h1 className="leading-none text-4xl font-extrabold">
        <span className="magical-gradient">Shop </span>items
        </h1> */}



      <style jsx>{`
        .shopcontainer {
          min-height: 50vh;
          padding: 0 0.5rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

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

    <div >
      <div class="row">
        <div class="col img-bottom japan" align="center">
          <br />
          <small><b>くたばれ~</b></small>
          <Lottie options={japanCat}
            height={250}
            width={250}
            isStopped={false}
            isPaused={false} />
          <p></p>
        </div>
        <div class="col img-bottom hawaii" align="center">
          <br />
          <small><b>Aloha!</b></small>
          <Lottie options={hawaiiCat}
            height={250}
            width={250}
            isStopped={false}
            isPaused={false} />
          {/* <small><b>Push Ups</b></small> */}
          <p></p>
        </div>

        <div class="col img-bottom singapore" align="center">
          <br />
          <small><b>I am dead inside.</b></small>
          <Lottie options={ntuCat}
            height={250}
            width={250}
            isStopped={false}
            isPaused={false} />
          {/* <small><b>Sit Ups</b></small> */}
          <p></p>
        </div>

      </div>


      <div className="container" align='center'>
        <br />  <br />
        <span className="magical-gradient text-3xl">🐱</span>
        <h4 className="leading-none font-extrabold text-2xl">
          Your avatar is a cari<span className="magical-gradient">cat</span>ure of your physical wellbeing.
        </h4>
        <div style={{ maxWidth: '60rem' }} >
          <p className='lead'>
            Clock steps and complete challenges in exchange for coins which can be used to customise your avatar and home background. Be careful not to slack off too much though, or your cat might just...
        </p>
        </div>
        <button type="button" class="btn btn-blue btn-lg">Watch Tour</button>
        <br />
        <br />
        <br />
        <br />
      </div>

    </div>




  </>
  )
}


