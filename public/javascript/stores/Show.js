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
            article.innerHTML = `
            <div> 
                <div id="user-review-data-${json.review_id}" class="review-${json.review_id}">
                    <div id="${review.title.replace(' ', '-')}">
                        <h4 id="user-review-title-${json.review_id}">${review.title}</h4>
                        <p>By <a id="review-user-id-${json.review_id}" href="/users/${review.user_id}">${json.username}</a>:</p>
                    </div>
                    
                    <div>
                        <p id="user-review-content-${json.review_id}">${review.content}</p>
                    </div>
                </div>

                <div id="button-container-${json.review_id}">
                    <button id="edit-review-${json.review_id}">Edit</button>
                    <button id="delete-review-${json.review_id}">Delete</button>
                </div>
            </div>
            `
            storeReviewContainer.appendChild(article);
        })
    })
}

submitReview();