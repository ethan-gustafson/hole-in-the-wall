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
                <input id="name" type="text" name="user[name]" value="${nameInnerText}" autcomplete="on">
            </div>

            <div>
                <label for="username">Username:</label>
                <input id="username" type="text" name="user[username]" value="${usernameInnerText}" autcomplete="on">
            </div>

            <div>
                <label for="email">Email:</label>
                <input id="email" type="email" name="user[email]" value="${emailInnerText}" autcomplete="on">
            </div>

            <div>
                <input id="submit" type="submit" value="Submit Changes"> 
            </div>
        </form>
        <p><a href="${window.location["pathname"]}">Cancel</a></p>
        `;
    })

}

accountEdit()