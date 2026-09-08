const form = document.getElementById("signup-form");
const signupSection = document.getElementById("signup-section");
const successSection = document.getElementById("success-section");
const errorModal = document.getElementById("error-modal");

const tryAgain = document.getElementById("try-again");
const signupButton = document.getElementById("signup-button");

tryAgain.addEventListener("click", () => {
  errorModal.hidden = true;
});

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  signupButton.disabled = true;
  signupButton.innerHTML = "⏳ Creating account...";

  const response = await fetch("/api/signup", {
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

  signupButton.disabled = false;
  signupButton.innerHTML = "Create account";

  if (data.success) {
    signupSection.hidden = true;
    successSection.hidden = false;
  } else {
    errorModal.hidden = false;
  }

  console.log("res", data);
});