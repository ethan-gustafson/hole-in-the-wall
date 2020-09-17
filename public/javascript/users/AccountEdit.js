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

            <div class="user-info-flex">
                <label for="name">Name:</label>
            </div>

            <div class="user-info-flex">
                <input id="hidden" type="hidden" name="_method" value="patch">
                <input class="input-size" id="name" type="text" name="user[name]" value="${nameInnerText}" autcomplete="on">
            </div>

            <div class="user-info-flex">
                <label for="username">Username:</label>
            </div>

            <div class="user-info-flex">
                <input class="input-size" id="username" type="text" name="user[username]" value="${usernameInnerText}" autcomplete="on">
            </div>

            <div class="user-info-flex">
                <label for="email">Email:</label>
            </div>

            <div class="user-info-flex">
                <input class="input-size" id="email" type="email" name="user[email]" value="${emailInnerText}" autcomplete="on">
            </div>

            <div class="user-info-flex">
                <input class="submit-edit-button" id="submit" type="submit" value="Submit Changes"> 
            </div>

            <p><a href="${window.location["pathname"]}">Cancel</a></p>
        </form>
        `;
    })

}

accountEdit()