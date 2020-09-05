var form = document.getElementById("signup-form");
var invalidMessage = document.getElementById("invalid-signup");

form.addEventListener("submit", () => {
    var submitContainer = document.getElementById("signup-submit-container");
    var paragraphTag = document.createElement("h3");
    var loadingMessage = document.createTextNode("Signing up...");
    
    paragraphTag.appendChild(loadingMessage);
    submitContainer.appendChild(paragraphTag);
    invalidMessage ? invalidMessage.remove() : null 
})