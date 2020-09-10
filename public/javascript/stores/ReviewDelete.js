function reviewDelete(){
    var userData = document.getElementById("user-review-data");
    var buttonContainer = document.getElementById("button-container");
    let deleteButton = document.getElementById("delete-review");

    deleteButton.addEventListener("click", event => {
        event.preventDefault();

        deleteButton.remove();

        let permissionButton = document.createElement("button");
        permissionButton.innerHTML = "Are You Sure?"

        buttonContainer.appendChild(permissionButton);

        permissionButton.addEventListener("click", event => {
            event.preventDefault()

            var reviewIdContainer = userData.className;
            var reviewId = reviewIdContainer.slice(reviewIdContainer.length - 1, reviewIdContainer.length);

            let review = {id: reviewId};

            let req = { 
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify(review)
            }

            fetch(`/reviews/${reviewId}`, req)
            .then(resp => resp.json())
            .then(json => {
                console.log(json)

                if (json.message == "Success"){
                    buttonContainer.remove();
                    userData.remove();
                }
            })
        })
    })
}

reviewDelete();