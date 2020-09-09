// Will configure review editing, deleting

function submitReview(){
    let reviewForm = document.getElementById("new-review-form");

    reviewForm.addEventListener("submit", event => {
        event.preventDefault();

        let reviewTitle = document.getElementById("review-title").value;
        let reviewContent = document.getElementById("review-content").value;
        let reviewUserId = document.getElementById("user_id").value;
        let reviewStoreId = document.getElementById("store_id").value;

        let review = {
            title: reviewTitle,
            content: reviewContent,
            user_id: reviewUserId,
            store_id: reviewStoreId
        }

        post = { 
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify(review)
        }

        fetch("/reviews", post)
        .then(resp => resp.json())
        .then(json => {
            console.log(json)
        })
    })
}

submitReview();