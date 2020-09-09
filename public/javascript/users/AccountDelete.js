function accountDelete(){
    var deleteButton = document.getElementById("user-delete-button");
    deleteButton.addEventListener("click", event => {
        event.preventDefault();

        deleteButton.innerHTML = "Are You Sure?";

        deleteButton.addEventListener("click", event => {
            event.preventDefault();

            deleteButton.remove();
            let buttonsContainer = document.getElementById("account-buttons-container");

            let form = document.createElement("form");
            form.action = `${window.location['pathname']}/delete`;
            form.method = "GET";

            let inputDeleteButton = document.createElement("input");
            inputDeleteButton.type = "submit";
            inputDeleteButton.value = "Permanently Delete Account";
            inputDeleteButton.style = "background-color:red;color:white;";

            form.appendChild(inputDeleteButton);
            buttonsContainer.appendChild(form);
        })
    })
}

accountDelete()