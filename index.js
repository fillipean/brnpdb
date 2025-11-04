class IndexHeader extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <!-- Index Header -->
      <header>

        <!-- Nav Bar -->
        <nav id="navbar" class="navbar navbar-light navbar-expand-sm fixed-top">
          <div class="container">
            <a class="navbar-brand title font-weight-lighter" href="./index.html">
              <span class="font-weight-bold">BrNPDB</span>
            </a>
            
            <!-- Navbar Toggle -->
            <button class="navbar-toggler collapsed ml-auto" type="button" data-toggle="collapse"
                    data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                    aria-label="Toggle navigation">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar top-bar"></span>
              <span class="icon-bar middle-bar"></span>
              <span class="icon-bar bottom-bar"></span>
            </button>
            <div class="collapse navbar-collapse text-center" id="navbarNav">
              <ul class="navbar-nav ml-auto flex-nowrap">

                <!-- About -->
                <li class="nav-item active">
                  <a class="nav-link" href="./index.html">
                    about
                    <span class="sr-only">(current)</span>
                  </a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="https://brnpdb.shinyapps.io/BrNPDB/">
                    search compounds
                  </a>
                </li>

                <!--  
                  <li class="nav-item">
                    <a class="nav-link" href="./query/index.html">
                      query
                    </a>
                  </li>
                  <li class="nav-item">
                    <a class="nav-link" href="./ontology/index.html">
                      ontology
                    </a>
                  </li> 
                -->

                <li class="nav-item">
                  <a class="nav-link" href="./license/index.html">
                    license
                  </a>
                </li>
                <li class="nav-item">
                  <a class="nav-link" href="./partners/index.html">
                    contact
                  </a>
                </li>
                <li><button id="light-toggle"></button></li>
              </ul>
            </div>
          </div>
        </nav>
      </header>
    `;

    //Decide on first render what color theme was chosen and display other theme to tell the user how to change the color theme
    let colorTheme = localStorage.getItem("theme");
    if (colorTheme === "light") {
      // document.getElementById("light-toggle").innerText = "Darkmode"
      document.getElementById(
        "light-toggle"
      ).innerHTML = `<img class="icon" src="./assets/img/darkmode.svg">`;
    } else {
      document.getElementById(
        "light-toggle"
      ).innerHTML = `<img class="icon" src="./assets/img/lightmode.svg">`;
    }
  }
}

class SubPageHeader extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <!-- Index Header -->
      <header>

        <!-- Nav Bar -->
        <nav id="navbar" class="navbar navbar-light navbar-expand-sm fixed-top">
          <div class="container">
              <a class="navbar-brand title font-weight-lighter" href="../index.html">
                <span class="font-weight-bold">BrNPDB</span>
              </a>

            <!-- Navbar Toggle -->
            <button class="navbar-toggler collapsed ml-auto" type="button" data-toggle="collapse"
                    data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                    aria-label="Toggle navigation">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar top-bar"></span>
              <span class="icon-bar middle-bar"></span>
              <span class="icon-bar bottom-bar"></span>
            </button>
            <div class="collapse navbar-collapse text-right" id="navbarNav">
              <ul class="navbar-nav ml-auto flex-nowrap">

                <!-- About -->
                <li id="about-page" class="nav-item">
                  <a class="nav-link" href="../index.html">
                    about
                    <span class="sr-only">(current)</span>
                  </a>
                </li>
                <li id="dashboard-page" class="nav-item">
                  <a class="nav-link" href="https://brnpdb.shinyapps.io/BrNPDB/">
                    search compounds
                  </a>
                </li>

                <!-- 
                  <li id="query-page" class="nav-item ">
                    <a class="nav-link" href="../query/index.html">
                      query
                    </a>
                  </li>
                  <li id="ontology-page" class="nav-item">
                    <a class="nav-link" href="../ontology/index.html">
                      ontology
                    </a>
                  </li>
                -->

                <li id="license-page" class="nav-item">
                  <a class="nav-link" href="../license/index.html">
                    license
                  </a>
                </li>
                <li id="contact-page" class="nav-item">
                  <a class="nav-link" href="../partners/index.html">
                    contact
                  </a>
                </li>
                <li>
                <button id="light-toggle"></button>
              </li>
              </ul>
            </div>
          </div>
        </nav>
      </header>
    `;

    //Decide on first render what color theme was chosen and display other theme to tell the user how to change the color theme
    let colorTheme = localStorage.getItem("theme");
    if (colorTheme === "light") {
      // document.getElementById("light-toggle").innerText = "Darkmode"
      document.getElementById(
        "light-toggle"
      ).innerHTML = `<img class="icon" src="../assets/img/darkmode.svg">`;
    } else {
      document.getElementById(
        "light-toggle"
      ).innerHTML = `<img class="icon" src="../assets/img/lightmode.svg">`;
    }

    //Split url and get sring between two '/'
    let subPageString = window.location.pathname.split(/[//]/)[1];

    //Check url to find out what subpage the user in on
    switch (subPageString) {
      case "ontology":
        document.getElementById("ontology-page").classList.add("active");
        break;
      case "query":
        document.getElementById("query-page").classList.add("active");
        break;
      case "dataset":
        document.getElementById("dataset-page").classList.add("active");
        break;
      case "license":
        document.getElementById("license-page").classList.add("active");
        break;
      case "partners":
        document.getElementById("partners-page").classList.add("active");
        break;
      case "changelog":
        document.getElementById("changelog-page").classList.add("active");
        break;
      case "contact":
        document.getElementById("contact-page").classList.add("active");
        break;
      case "ontology":
        document.getElementById("ontology-page").classList.add("active");
        break;
      case "docs":
        document.getElementById("docs-page").classList.add("active");
        break;
      default:
        console.log("something went wrong");
    }
  }
}

//Footer
class Footer extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `
      <!-- Footer -->
      <footer class="fixed-bottom bg-dark text-white">
        <div class="container text-center">
          <div class="row justify-content-center align-items-center">
            <div class="col-md-4">
              <p>BrNPDB © Copyright 2024 BrNPDB</p>
            </div>
            <!--
              <div class="col-md-4">
                <h6>Quick Links</h6>
                <ul class="list-unstyled">
                  <li><a href="./index.html" class="text-white">About</a></li>
                  <li><a href="https://brnpdb.shinyapps.io/BrNPDB/" class="text-white">Search Compounds</a></li>
                  <li><a href="./license/index.html" class="text-white">License</a></li>
                  <li><a href="./partners/index.html" class="text-white">Contact</a></li>
                </ul>
              </div>
              <div class="col-md-4">
                <h6>Follow Us</h6>
                <a href="https://twitter.com" target="_blank" class="text-white mx-2">
                  <i class="fab fa-twitter"></i>
                </a>
                <a href="https://facebook.com" target="_blank" class="text-white mx-2">
                  <i class="fab fa-facebook"></i>
                </a>
                <a href="https://linkedin.com" target="_blank" class="text-white mx-2">
                  <i class="fab fa-linkedin"></i>
                </a>
              </div>
            -->
          </div>
        </div>
      </footer>
    `;
  }
}

customElements.define("main-header", IndexHeader);
customElements.define("sub-header", SubPageHeader);
customElements.define("main-footer", Footer);
