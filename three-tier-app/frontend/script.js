const form = document.getElementById("login-form");
const loginSection = document.getElementById("login-section");
const successSection = document.getElementById("success-section");
const errorModal = document.getElementById("error-modal");

const tryAgain = document.getElementById("try-again");
const loginButton = document.getElementById("login-button");

tryAgain.addEventListener("click", () => {
  errorModal.hidden = true;
});

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  // Start spinner
  loginButton.disabled = true;
  loginButton.innerHTML = "⏳ Logging in...";

  const response = await fetch("http://localhost:8080/api/login", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      email,
      password
    })
  });

  const data = await response.json();

  // Stop spinner
  loginButton.disabled = false;
  loginButton.innerHTML = "Login";

  if (data.success) {
    loginSection.hidden = true;
    successSection.hidden = false;
  } else {
    errorModal.hidden = false;
  }

  console.log("res",data);
});