function changeReviewToForm(){
    var userData = document.getElementById("user-review-data");
    var userDataReviewTitleNode = document.getElementById("user-review-title");
    var userDataReviewContentNode = document.getElementById("user-review-content");

    var buttonContainer = document.getElementById("button-container");
    var editButton = document.getElementById("edit-review");

    editButton.addEventListener("click", event => {
        event.preventDefault();
        editButton.style.display = "none";

        let title = userDataReviewTitleNode.innerText;
        let content = userDataReviewContentNode.innerText;

        userData.innerHTML = `
        <div>
            <form id="review-update-form">
                <div>
                    <label for="input-title">Title: </label>
                    <input id="input-title" type="text" name="title" value="${title}">
                </div>

                <div>
                <label for="textarea-content">Content: </label>
                    <textarea id="textarea-content">${content}</textarea>
                </div>
            </form>
        </div>
        `

        let submitButton = document.createElement("button");
        
        submitButton.id = "submit-updated-review";
        submitButton.innerHTML = "Submit Changes";
        buttonContainer.appendChild(submitButton);

        submitButton.addEventListener("click", event => {
            event.preventDefault();

            var reviewIdContainer = userData.className;
            var reviewId = reviewIdContainer.slice(reviewIdContainer.length - 2, reviewIdContainer.length);

            let fetchTitle = document.getElementById("input-title").value;
            let fetchContent = document.getElementById("textarea-content").value;

            sendReviewUpdatesFetch(editButton, submitButton, {
                id: reviewId,
                title: fetchTitle, 
                content: fetchContent
            });
        })
    })
}

function sendReviewUpdatesFetch(editButton, submitButton, object){
    var userData = document.getElementById("user-review-data");

    let patch = { 
        method: "PATCH",
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        body: JSON.stringify(object)
    }

    fetch(`/reviews/${object.id}`, patch)
    .then(resp => resp.json())
    .then(json => {
        console.log(json)

        if (json.message == "Success"){
            submitButton.remove();
            userData.innerHTML = `
            <div id="${object.title.replace(' ', '-')}" class="${object.id}">
                <h4 id="user-review-title">${object.title}</h4>
                <p>By: <a id="review-user-id" href="/users/${json.user_id}">${json.username}</a></p>
            </div>
            <div>
                <p id="user-review-content">${object.content}</p>
            </div>
            `
            editButton.style.display = "";
        } else {
            var error = document.createElement("p");
            error.id = "review-submit-error"
            error.innerHTML = "error"
            userData.appendChild(error);
        }
    })
}

changeReviewToForm();