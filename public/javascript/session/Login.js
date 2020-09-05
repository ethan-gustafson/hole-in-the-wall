// Will display misc items on Login page

var form = document.getElementById("login-form");

form.addEventListener("submit", () => {
    var submitContainer = document.getElementById("login-submit-container");
    var paragraphTag = document.createElement("p");
    var loadingMessage = document.createTextNode("Logging in...");
    
    paragraphTag.appendChild(loadingMessage);
    submitContainer.appendChild(paragraphTag);
})