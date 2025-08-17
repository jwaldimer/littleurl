import { Controller } from "@hotwired/stimulus"
alert("ty");

document.addEventListener("DOMContentLoaded", () => {
  const originalUrlInput = document.querySelector("#little_url_original_url");
  const tokenInput = document.querySelector("#little_url_token");
  const submitButton = document.querySelector("#submit-button");

  function validateForm() {
    const urlFilled = originalUrlInput.value.trim() !== "";
    const tokenFilled = tokenInput.value.trim() !== "";
    submitButton.disabled = !(urlFilled && tokenFilled);
  }

  originalUrlInput.addEventListener("input", validateForm);
  tokenInput.addEventListener("input", validateForm);
});
