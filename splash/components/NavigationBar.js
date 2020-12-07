import Link from 'next/link';

const NavigationBar = () => (
  <>
    <nav class="navbar navbar-expand-lg fixed-top">
      <a class="navbar-brand" href="/">
        {/* <span><img src="/fettle2.ico" /></span> */}
        <h3 class="navbar-text">fettle</h3>
      </a>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarText">
        <ul class="nav justify-content-center ml-auto mx-auto">
          <li class="nav-item">
            <a class="nav-link" href="/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/getstarted">Guide</a>
          </li>
          {/* <li class="nav-item">
            <a class="nav-link" href="/news&events">News & Events</a>
          </li> */}
          {/* <li class="nav-item">
            <a class="nav-link" href="/tour">Tour</a>
          </li> */}
          <li class="nav-item">
            <a class="nav-link" href="/aboutus">About Us</a>
          </li>
        </ul>
      </div>
      <button type="button" class="btn btn-success">Download</button>
    </nav >
    <br />
    <br />
  </>
);

export default NavigationBar;

