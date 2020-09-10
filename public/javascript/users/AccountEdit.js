function accountEdit(){
    // Grab the div tag account-info id
    var accountInfo = document.getElementById("account-info");
    // Grab the user-edit button && user-delete button
    var editButton = document.getElementById("user-edit-button");

    // When the button is clicked, 
    editButton.addEventListener("click", event => {
        event.preventDefault();
        // Grab the account information tags
        var username = document.getElementById("account-username");
        var name = document.getElementById("account-name");
        var email = document.getElementById("account-email");
        // Grab the account information innerTexts
        var usernameInnerText = username.innerText;
        var nameInnerText = name.innerText;
        var emailInnerText = email.innerText;

        // replace the edit button with a submit button
        editButton.remove();

        accountInfo.innerHTML = `
        <form id="user-edit" action="${window.location["pathname"]}" method="POST">
            <input id="hidden" type="hidden" name="_method" value="patch">

            <div>
                <label for="name">Name:</label>
                <input id="name" type="text" name="name" value="${nameInnerText}" autcomplete="on">
            </div>

            <div>
                <label for="username">Username:</label>
                <input id="username" type="text" name="username" value="${usernameInnerText}" autcomplete="on">
            </div>

            <div>
                <label for="email">Email:</label>
                <input id="email" type="email" name="email" value="${emailInnerText}" autcomplete="on">
            </div>

            <div>
                <input id="submit" type="submit" value="Submit Changes"> 
            </div>
        </form>
        <p><a href="${window.location["pathname"]}">Cancel</a></p>
        `;
        let form = document.getElementById("user-edit");
        accountSubmit(form)
    })

}

function accountSubmit(form){
    // when the user submits, 
    // replace the submit button with the original buttons,
    // take the values from the inputs, 
    // delete the form,
    // put values back inside original tags,
    // update DOM.
    var accountInfo = document.getElementById("account-info");
    var buttonsContainer = document.getElementById("account-buttons-container");

    if (!!form){
        form.addEventListener("submit", event => {
            event.preventDefault();
            let submitting = document.createElement("p");
            submitting.innerHTML = "Submitting..";
            accountInfo.appendChild(submitting);

            let name = document.getElementById("name").value;
            let username = document.getElementById("username").value;
            let email = document.getElementById("email").value;

            let updatedUser = {
                name: name,
                username: username,
                email: email
            }

            let post = { 
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify(updatedUser)
            }

            fetch(`${window.location["pathname"]}`, post)
            .then(resp => resp.json())
            .then(json => {
                console.log(json);

                if (json.message === "Success"){
                    accountInfo.innerHTML = `
                        <div id="account-info">
                            <h3 id="account-name">${name}</h3>
                            <h2 id="account-username">${username}</h2>
                            <h3 id="account-email">${email}</h3>
                            <p style="color:red;">Success :)</p>
                        </div>
                    `;
                    let editButton = document.createElement("button");
                    editButton.id = "user-edit-button";
                    editButton.innerHTML = "Edit Account"
                    buttonsContainer.appendChild(editButton);
                } else {
                    let invalid = "<p>Something Went Wrong</p>"
                    accountInfo.appendChild(invalid);
                }
            })
        })
    }
}

accountEdit()