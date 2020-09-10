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

        let post = { 
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

            let storeReviewContainer = document.getElementById("store-reviews");

            let article = document.createElement("article");
            let heading = document.createElement("h4");
            let p = document.createElement("p");

            heading.innerHTML = `<a href='/users/${reviewUserId}'>${json.user}: ${reviewTitle}</a>`;
            p.innerHTML = `${reviewContent}`;

            article.appendChild(heading);
            article.appendChild(p);
            storeReviewContainer.appendChild(article);
        })
    })
}

submitReview();