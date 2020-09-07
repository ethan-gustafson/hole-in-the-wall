function accountEdit(){
    // Grab the div tag account-info id
    var accountInfo = document.getElementById("account-info");
    // Grab the account information tags
    var username = document.getElementById("account-username");
    var name = document.getElementById("account-name");
    var email = document.getElementById("account-email");
    // Grab the account information innerTexts
    var usernameInnerText = username.innerText;
    var nameInnerText = name.innerText;
    var emailInnerText = email.innerText;
    // Grab the user-edit button && user-delete button
    var editButton = document.getElementById("user-edit-button");

    // When the button is clicked, 
    editButton.addEventListener("click", event => {
        event.preventDefault();

        // replace the edit button with a submit button
        editButton.remove();
        // create a form,
        var form = document.createElement("form");
        form.id = "user-edit";
        form.action = window.location["pathname"];
        form.method = "POST";
        // create inputs with the values from the original tags
        var hidden = document.createElement("input");
        var nameInput = document.createElement("input");
        var usernameInput = document.createElement("input");
        var emailInput = document.createElement("input");
        var submitButton = document.createElement("input");
        // create input id's
        hidden.id = "hidden";
        nameInput.id = "name";
        usernameInput.id = "username";
        emailInput.id = "email";
        // define the inputs attributes
        // hidden:
        hidden.type = "hidden";
        hidden.name = "_method";
        hidden.value = "patch";
        // name:
        nameInput.type = "text";
        nameInput.name = "user[name]";
        nameInput.value = nameInnerText;
        nameInput.autocomplete = "on";
        // username:
        usernameInput.type = "text";
        usernameInput.name = "user[username]";
        usernameInput.value = usernameInnerText;
        usernameInput.autocomplete = "on";
        // email:
        emailInput.type = "text";
        emailInput.name = "user[email]";
        emailInput.value = emailInnerText;
        emailInput.autocomplete = "on";
        // submit: 
        submitButton.id = "submit";
        submitButton.type = "submit";
        submitButton.value = "Submit Changes";
        // create labels for the inputs 
        var nameInputLabel = document.createElement("label");
        var usernameInputLabel = document.createElement("label");
        var emailInputLabel = document.createElement("label");
        // define the label attributes
        // label name: 
        nameInputLabel.htmlFor = "name";
        nameInputLabel.innerHTML = "Name:";
        // label username: 
        usernameInputLabel.htmlFor = "username";
        usernameInputLabel.innerHTML = "Username:";
        // label email: 
        emailInputLabel.htmlFor = "email";
        emailInputLabel.innerHTML = "Email:";

        // create input div's for css
        var usernameDiv = document.createElement("div");
        var nameDiv = document.createElement("div");
        var emailDiv = document.createElement("div");
        var submitDiv = document.createElement("div");

        usernameDiv.appendChild(usernameInputLabel);
        usernameDiv.appendChild(usernameInput);

        nameDiv.appendChild(nameInputLabel);
        nameDiv.appendChild(nameInput);

        emailDiv.appendChild(emailInputLabel);
        emailDiv.appendChild(emailInput);

        submitDiv.appendChild(submitButton);

        form.appendChild(hidden);
        form.appendChild(usernameDiv);
        form.appendChild(nameDiv);
        form.appendChild(emailDiv);
        form.appendChild(submitDiv)
        // remove the tags, 
        username.remove();
        name.remove();
        email.remove();
        // append the form to the div tag account-info id
        accountInfo.appendChild(form);
        // accountSubmit(form);
    })

}

function accountSubmit(form){
        // when the user submits, 
        // replace the submit button with the original buttons,
        // take the values from the inputs, 
        // delete the form,
        // put values back inside original tags,
        // update DOM.
}

accountEdit()