const registrationForm = document.querySelector("#registrationForm");
const summaryDialog = document.querySelector("#summaryDialog");
const closeSummaryButton = document.querySelector("#closeSummary");

const fields = {
  fullName: {
    input: document.querySelector("#fullName"),
    error: document.querySelector("#fullNameError"),
    validate(value) {
      return value.trim().length >= 2 ? "" : "Shkruaj emrin me të paktën 2 karaktere.";
    }
  },
  email: {
    input: document.querySelector("#email"),
    error: document.querySelector("#emailError"),
    validate(value) {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return emailPattern.test(value.trim()) ? "" : "Shkruaj një email të vlefshëm.";
    }
  },
  password: {
    input: document.querySelector("#password"),
    error: document.querySelector("#passwordError"),
    validate(value) {
      return value.length >= 8 ? "" : "Password-i duhet të ketë minimumi 8 karaktere.";
    }
  },
  role: {
    input: document.querySelector("#role"),
    error: document.querySelector("#roleError"),
    validate(value) {
      return value ? "" : "Zgjidh një role/status.";
    }
  }
};

function setFieldState(field, errorMessage) {
  const fieldWrapper = field.input.closest(".field");

  field.error.textContent = errorMessage;
  fieldWrapper.classList.toggle("is-invalid", Boolean(errorMessage));
  fieldWrapper.classList.toggle("is-valid", !errorMessage && Boolean(field.input.value.trim()));
}

function validateField(field) {
  const errorMessage = field.validate(field.input.value);
  setFieldState(field, errorMessage);
  return !errorMessage;
}

function validateForm() {
  const validationResults = Object.values(fields).map(validateField);
  return validationResults.every(Boolean);
}

function showSummary() {
  document.querySelector("#summaryName").textContent = fields.fullName.input.value.trim();
  document.querySelector("#summaryEmail").textContent = fields.email.input.value.trim();
  document.querySelector("#summaryRole").textContent = fields.role.input.value;

  if (typeof summaryDialog.showModal === "function") {
    summaryDialog.showModal();
    return;
  }

  alert(`Regjistrimi u krye me sukses për ${fields.fullName.input.value.trim()}.`);
}

Object.values(fields).forEach((field) => {
  field.input.addEventListener("input", () => validateField(field));
  field.input.addEventListener("blur", () => validateField(field));
});

registrationForm.addEventListener("submit", (event) => {
  event.preventDefault();

  if (!validateForm()) {
    return;
  }

  showSummary();
  registrationForm.reset();
  Object.values(fields).forEach((field) => setFieldState(field, ""));
});

closeSummaryButton.addEventListener("click", () => {
  summaryDialog.close();
});
